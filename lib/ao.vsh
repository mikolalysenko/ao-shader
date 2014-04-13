attribute vec4 attrib0;
attribute vec4 attrib1;

uniform mat4 projection;
uniform mat4 view;
uniform mat4 model;
uniform float tileCount;

varying vec3  normal;
varying vec2  tileCoord;
varying vec2  texCoord;
varying float ambientOcclusion;

void main() {
  //Compute position
  vec3 position = attrib0.xyz;
  
  //Compute ambient occlusion
  ambientOcclusion = attrib0.w / 255.0;
  
  //Compute normal
  normal = 128.0 - attrib1.xyz;
  
  //Compute texture coordinate
  texCoord = vec2(dot(position, vec3(normal.y-normal.z, 0, normal.x)),
                  dot(position, vec3(0, -abs(normal.x+normal.z), normal.y)));
  
  //Compute tile coordinate
  float tx    = attrib1.w / tileCount;
  tileCoord.x = floor(tx);
  tileCoord.y = fract(tx) * tileCount;
  
  gl_Position = projection * view * model * vec4(position, 1.0);
}
