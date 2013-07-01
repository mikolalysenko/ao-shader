precision highp float;

uniform float tileSize;
uniform sampler2D tileMap;

varying vec2 texOffset;
varying vec2 texCoord;
varying float ambientOcclusion;

void main() {
  vec2 tc = texOffset + tileSize * (texCoord - floor(texCoord));
  vec4 color = texture2D(tileMap, tc);
  
  gl_FragColor = vec4(color.xyz * ambientOcclusion, color.w);
}