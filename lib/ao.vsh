attribute vec4 attrib0;
attribute vec4 attrib1;

uniform mat4 projection;
uniform mat4 view;
uniform mat4 model;

varying vec3  normal;
varying vec2  tileCoord;
varying vec2  texCoord;
varying float ambientOcclusion;

void main() {
  //Compute position
  vec3 position = attrib0.xyz;
  
  //Compute ambient occlusion
  ambientOcclusion = attrib0.w / 4.0;
  
  //Compute normal
  int side = int(attrib1.x);
  if(side == 0) {
    normal = vec3(1, 0, 0);
  } else if(side == 1) {
    normal = vec3(0, 1, 0);
  } else if(side == 2) {
    normal = vec3(0, 0, 1);
  } else if(side == 3) {
    normal = vec3(-1, 0, 0);
  } else if(side == 4) {
    normal = vec3(0, -1, 0);
  } else if(side == 5) {
    normal = vec3(0, 0, -1);
  }
  
  //Compute texture coordinate
  texCoord = attrib1.yz;
  
  //Compute tile coordinate
  float tx    = attrib1.w / 16.0;
  tileCoord.x = floor(tx);
  tileCoord.y = fract(tx) * 16.0;
  
  gl_Position = projection * view * model * vec4(position, 1.0);
}
