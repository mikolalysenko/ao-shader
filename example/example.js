var shell = require("gl-now")()
var camera = require("game-shell-orbit-camera")(shell)
var createTileMap = require("gl-tile-map")
var createBuffer = require("gl-buffer")
var createVAO = require("gl-vao")
var ndarray = require("ndarray")
var fill = require("ndarray-fill")
var ops = require("ndarray-ops")
var terrain = require("isabella-texture-pack")
var createAOMesh = require("ao-mesher")
var createAOShader = require("../aoshader.js")
var glm = require("gl-matrix")
var mat4 = glm.mat4

//WebGL state
var shader, texture, vao, vertexCount

//Voxel resolution
var resolution = [32,32,32]

//Modify this to generate different terrains:
function generateVoxels(i,j,k) {
  var x = i - 16
  var y = j - 16
  var z = k - 16
  if(x*x+y*y+z*z < 30) {
    if(k < 16) {
      return 1<<15
    }
    return (1<<15)+1
  }  
  return 0
}


shell.on("gl-init", function() {
  var gl = shell.gl

  //Create shader
  shader = createAOShader(gl)
  
  //Create some voxels
  var voxels = ndarray(new Int32Array(resolution[0]*resolution[1]*resolution[2]),
                      resolution)
  fill(voxels, generateVoxels)
  
  //Set up camera
  var c = [resolution[0]>>>1, resolution[1]>>>1, resolution[2]>>>1]
  camera.lookAt([c[0], c[1], c[2]+2*resolution[2]], c, [0,1,0])
  
  //Compute mesh
  var vert_data = createAOMesh(voxels)
  
  //Convert mesh to WebGL buffer
  vertexCount = vert_data.length>>3
  var vert_buf = createBuffer(gl, vert_data)
  vao = createVAO(gl, undefined, [
    { "buffer": vert_buf,
      "type": gl.UNSIGNED_BYTE,
      "size": 4,
      "offset": 0,
      "stride": 8,
      "normalized": false
    },
    { "buffer": vert_buf,
      "type": gl.UNSIGNED_BYTE,
      "size": 4,
      "offset": 4,
      "stride": 8,
      "normalized": false
    }
  ])
  
  //Load texture map
  var tiles = ndarray(terrain.data,
    [16,16,terrain.shape[0]>>4,terrain.shape[1]>>4,4],
    [terrain.stride[0]*16, terrain.stride[1]*16, terrain.stride[0], terrain.stride[1], terrain.stride[2]], 0)
  texture = createTileMap(gl, tiles, true)
  texture.mipSamples = 4
})

shell.on("gl-render", function(t) {
  var gl = shell.gl
  var A = mat4.create()
  
  //Set WebGL parameters
  gl.enable(gl.CULL_FACE)
  gl.enable(gl.DEPTH_TEST)

  //Bind the shader
  shader.bind()
  
  //Set shader attributes and uniforms
  shader.attributes.attrib0.location = 0
  shader.attributes.attrib1.location = 1
  shader.uniforms.projection = mat4.perspective(A, 
                                                Math.PI/4.0, 
                                                shell.width/shell.height, 
                                                1.0, 
                                                1000.0)
  shader.uniforms.view = camera.view()
	shader.uniforms.model = mat4.identity(A)
  shader.uniforms.tileMap = texture.bind()
  shader.uniforms.tileSize = 16.0
  shader.uniforms.tileCount = 16.0

  //Draw object
  vao.bind()
  gl.drawArrays(gl.TRIANGLES, 0, vertexCount)
  vao.unbind()
})
