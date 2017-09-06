'use strict';

console.log('Loading function');

exports.handler = (event, context, callback) => {
    //console.log('Received event:', JSON.stringify(event, null, 2));
    console.log('value1 =', event.key1);

    var response = {
      "message": event.key1
    }

    callback(null, response);  // Echo back the first key value

};
