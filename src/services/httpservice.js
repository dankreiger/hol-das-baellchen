var Fetch = require('whatwg-fetch');

var baseUrl = 'http://localhost:6060';


var service = {
  get: function(url) {
    console.log('making request');
    console.log('baseUrl: '+baseUrl);
    console.log('url: '+url);
    return fetch(baseUrl + url)
    .then(function(response){
      return response.json();
    });
  }
}

module.exports = service;
