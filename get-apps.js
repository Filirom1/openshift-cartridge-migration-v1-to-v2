#!/usr/bin/env node

var login = process.argv[2];

if(!login){
  throw new Error('Usage: ' + __filename + ' login');
}

var request = require('request').defaults({
  json: true,
  headers: {
    "X-Remote-User": login,
  }
});

request.get({
  url: 'http://localhost:8080/broker/rest/domains'
}, function(err, resp, body){
  if(err) throw err;
  if(resp.statusCode != 200) throw new Error('status code ' + resp.statusCode + ' != 200', body);
  body.data.forEach(function(domain){
    var domainId = domain.id;
    request.get({
      url: 'http://localhost:8080/broker/rest/domains/' + domainId + '/applications'
    }, function(err, resp, body){
      if(err) throw err;
      if(resp.statusCode != 200) throw new Error('status code ' + resp.statusCode + ' != 200', body);
      body.data.forEach(function(app){
        console.log(login, domain.id, app.name, app.framework, app.git_url, Object.keys(app.embedded).join(','));
      })
    });
  });
});


