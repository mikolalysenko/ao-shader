attribute vec4 attrib0;
attribute vec4 attrib1;

uniform mat4 projection;
uniform mat4 view;
uniform mat4 model;

uniform float tileSize;

varying vec2  texOffset;
varying vec2  texCoord;
varying float ambientOcclusion;

void main() {
  vec3 position = attrib0.xyz;
  vec3 normal = attrib1.xyz;
  
  ambientOcclusion = attrib0.w / 4.0;
  
  //Compute tile offset
  float tx = attrib1.w/16.0;
  float ti = floor(tx);
  texOffset.x = ti * tileSize;
  texOffset.y = (tx - ti) * 16.0 * tileSize;
  
  //Compute tile coordinate
  texCoord = vec2(abs(dot(position, normal.yzx)), abs(dot(position, normal.zxy)));

  gl_Position = projection * view * model * vec4(position, 1.0);
}
