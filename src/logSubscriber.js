exports.main = pubsubMessage => {
  // Print out the data from Pub/Sub, to prove that it worked

  const dataStr = Buffer.from(pubsubMessage.data, 'base64').toString();
  const data = JSON.parse(dataStr);

  console.log(`attributes`, pubsubMessage.attributes);
  console.log(`message`, data);
};