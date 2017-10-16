'use strict'

const CompileCache = require(process.env.ATOM_SRC_ROOT + '/src/compile-cache')
const fs = require('fs')
const glob = require('glob')
const path = require('path')

module.exports = function () {
  let paths = new Set()

  for (let pattern of process.argv.slice(2)) {
    for (let path of glob.sync(pattern, {nodir: true})) {
      paths.add(path)
    }
  }

  for (let path of paths) {
    let jsPath = coffeePath.replace(/coffee$/g, 'js')
    fs.writeFileSync(
      jsPath, CompileCache.addPathToCache(coffeePath, process.env.ATOM_HOME))
    fs.unlinkSync(coffeePath)
  }
}
