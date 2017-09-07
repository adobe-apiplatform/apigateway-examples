'use strict';

console.log('Loading function');

/**
 * Return a simple greeting message for someone.
 *
 * @param name A person's name.
 * @param place Where the person is from.
 */
function main(params) {
    var name = params.name || params.payload || 'stranger';
    var place = params.place || 'somewhere';
    return {payload:  'Hello, ' + name + ' from ' + place + ' !'};
}

/**
* wrap the main function into a simple handler for AWS
*/
exports.handler = (event, context, callback) => {
  callback( null, main(event) );
}
