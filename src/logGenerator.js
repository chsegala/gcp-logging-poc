const { Logging, Log } = require('@google-cloud/logging');
const log = new Logging().log('logGenerator');


exports.main = (req, res) => {
  log.info(req);
  const message = `log id = missing`;
  res.status(200).send(message);
}