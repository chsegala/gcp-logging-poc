const logConsumer = require('./logConsumer');
const logGenerator = require('./logGenerator');
const logSubscriber = require('./logSubscriber');

exports.logConsumer = logConsumer.main;
exports.logGenerator = logGenerator.main;
exports.logSubscriber = logSubscriber.main;