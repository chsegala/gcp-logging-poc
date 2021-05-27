exports.main = (req, res) => {
  const headers = req.headers;
  const message = {
    headers
  };

  console.info(`headers ${JSON.stringify(message, null, 2)}`);
  console.info(`body ${JSON.stringify(req.body, null, 2)}`);
  res.status(200).json(message);
}