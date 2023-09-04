import express from "express";
import fetch from "node-fetch";
import dotenv from "dotenv";

const app = express();
const port = 3000;
const yelpRoot = "https://api.yelp.com/v3";
const yelp_api_key = dotenv.config().parsed.YELP_API_KEY;

app.listen(port, () => {
  console.log(`YELP PROXY ${port}`);
});

app.use(async (req, res) => {
  const response = await fetch(`${yelpRoot}${req.originalUrl}`, {
    method: "GET",
    headers: { Authorization: `Bearer ${yelp_api_key}` },
  });
  const result = await response.json();
  res.json(result);
});
