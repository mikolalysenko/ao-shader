precision highp float;

uniform float tileSize;
uniform sampler2D tileMap;
uniform float tileCount;

varying vec3  normal;
varying vec2  tileCoord;
varying vec2  texCoord;
varying float ambientOcclusion;

void main() {

  vec2 uv      = texCoord;
  vec4 color   = vec4(0,0,0,0);
  float weight = 0.0;

  vec2 tileOffset = 2.0 * tileSize * tileCoord;
  float denom     = 2.0 * tileSize * tileCount;

  for(int dx=0; dx<2; ++dx) {
    for(int dy=0; dy<2; ++dy) {
      vec2 offset = 2.0 * fract(0.5 * (uv + vec2(dx, dy)));
      float w = pow(1.0 - max(abs(offset.x-1.0), abs(offset.y-1.0)), 16.0);
      
      vec2 tc = (tileOffset + tileSize * offset) / denom;
      color  += w * texture2D(tileMap, tc);
      weight += w;
    }
  }
  color /= weight;
  
  if(color.w < 0.5) {
    discard;
  }
  
  float light = ambientOcclusion + max(0.15*dot(normal, vec3(1,1,1)), 0.0);
  
  gl_FragColor = vec4(color.xyz * light, 1.0);
}
