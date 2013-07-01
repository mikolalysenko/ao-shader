var fs = require("fs")
var createShader = require("gl-shader")

module.exports  = function(gl) {
  return createShader(gl,
    fs.readFileSync(__dirname+"/lib/ao.vsh"),
    fs.readFileSync(__dirname+"/lib/ao.fsh"))
}
