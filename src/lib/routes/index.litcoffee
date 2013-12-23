
# Application Routes

The purpose of a route is to connect URL resources with underlying code.  I
also do explicit data normalization (input -> dictionary to pass to method/dict
from method -> view) at this stage.

To configure routes, the only object we need access to is `app`.  This module
can be called with `require("./lib/routes")(app)` as long as `app` is an
already initialized ExpressJS application.

    module.exports = (app) ->

## GET /

Render the main index page.

      app.get '/', (req, res) ->
        res.render 'index', {
          title: 'Welcome'
        }

## GET /

Render the main index page.

      app.get '/game', (req, res) ->
        title = 'Gift Exchange'
        request = require '../../node_modules/request'
        request {
          url: 'https://docs.google.com/spreadsheet/pub?key=0ArrqhUPPrcPCdG5iV1hkRHdsVjJnTm84NW1RVnQ4WlE&single=true&gid=0&output=csv',
        }, (err, rres, body) ->
          if err
            res.render 'page', {
              title: title,
              body: 'Error #1: '+err
            }
          else
            presents = []
            gravatar = require '../../node_modules/gravatar'
            csv = require '../../node_modules/csv'
            csv().from.string(body).on('record', (row, index) ->
              return if index == 0
              presents.push {
                id: row[0],
                img: if row[4] then row[3] else row[2],
                detail: if row[4] then "#{row[1]} - #{row[5]}",
                ownerurl:
                  if row[6]
                    gravatar.url("#{row[6]}@zerolag.com",{s: '256', d: 'monsterid'})
                  else
                    "http://placehold.it/256x256&text=available"
                ,
                owner: if row[6] then "#{row[6]}@zerolag.com" else "nobody@zerolag.com"
              })
            res.render 'game', {
              title: title,
              presents: presents,
              debug: if 1 then JSON.stringify presents
            }

## GET /page/:name

Render static pages at /view/page/name.html

      app.get '/page/:name', (req, res) ->
        res.render 'page/'+req.params.name

## Copying

This software is released under the ISC License.

Copyright (c) 2013, Cameron King <cking@ecc12.com>

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.

<!-- vim: ts=2 sts=2 sw=2 expandtab
     CoffeeScript-friendly tabstops in vim. -->
