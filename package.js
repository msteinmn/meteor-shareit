Package.describe({
  summary: 'A meteor package that makes social sharing easy',
  git: 'https://github.com/msteinmn/meteor-shareit.git',
  version: '1.1.3',
  name: "msteinmn:shareit"
});

Package.onUse(function(api) {
  api.versionsFrom("METEOR@1.0");
  api.use(['coffeescript', 'templating', 'underscore', 'jquery'], 'client');
  api.use(['fortawesome:fontawesome@4.2.0'], 'client');

  api.addFiles([
    'shareit.coffee',
    'client/views/social.html',
    'client/views/social.coffee',
    'client/views/social.css',
    'client/views/facebook/facebook.html',
    'client/views/facebook/facebook.coffee',
    'client/views/twitter/twitter.html',
    'client/views/twitter/twitter.coffee',
    'client/views/googleplus/googleplus.html',
    'client/views/googleplus/googleplus.coffee',
    'client/views/pinterest/pinterest.html',
    'client/views/pinterest/pinterest.coffee',
    'client/views/linkedin/linkedin.html',
    'client/views/linkedin/linkedin.coffee'
  ], 'client');

  api.export('ShareIt', 'client');
});

// Package.onTest(function (api) {
//   api.use(['tinytest',
//     'test-helpers',
//     'templating',
//     'coffeescript'
//     ])
//     api.use('joshowens:shareit')

//   api.addFiles([
//     'tests/client.html',
//     'tests/client.js'
//     ], 'client')
// })
