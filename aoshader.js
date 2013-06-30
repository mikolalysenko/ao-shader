var fs = require("fs")
var createShader = require("gl-shader")

module.exports  = function(gl) {
  return createShader(gl,
    fs.readFileSync(__dirname+"/lib/aoshader.vs"),
    fs.readFileSync(__dirname+"/lib/aoshader.fs"))
}
