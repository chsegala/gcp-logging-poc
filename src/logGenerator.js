const { PubSub } = require('@google-cloud/pubsub');
const superagent = require('superagent');
const { CloudFunctionsServiceClient } = require("@google-cloud/functions");
const { url } = require('inspector');

const URL = "https://us-east1-gcp-logging-poc-314817.cloudfunctions.net/logConsumer";

exports.main = async (req, res) => {
  const headers = req.headers;
  const message = {
    headers
  };

  const functionPromise = superagent.post(URL)
    .set('x-cloud-trace-context', req.headers['x-cloud-trace-context'])
    .send(message)
    .catch(err => {
      console.log(err);
      Promise.resolve();
    });

  const topic = new PubSub().topic('function-pubsub');
  const topicPromise = topic.publish(Buffer.from(JSON.stringify({ message }), 'utf-8'))
    .catch(err => {
      console.log(err);
      Promise.resolve();
    });

  await Promise.all([functionPromise, topicPromise]);

  console.info(JSON.stringify(message, null, 2));
  res
    .status(200)
    .json(message);
}