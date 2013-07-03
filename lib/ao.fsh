precision highp float;

uniform float tileSize;
uniform sampler2D tileMap;

varying vec3  normal;
varying vec2  tileCoord;
varying vec2  texCoord;
varying float ambientOcclusion;

void main() {

  vec2 uv      = texCoord;
  vec4 color   = vec4(0,0,0,0);
  float weight = 0.0;

  vec2 tileOffset = 2.0 * tileSize * tileCoord;
  float denom     = 2.0 * tileSize * 16.0;

  for(int d=0; d<2; ++d) {
    vec2 offset = 2.0 * fract(0.5 * (uv + 0.5 + vec2(d, d)));
    float w = 1.0 - max(abs(offset.x-1.0), abs(offset.y-1.0));
    
    vec2 tc = (tileOffset + tileSize * offset) / denom;
    color  += w * texture2D(tileMap, tc);
    weight += w;
  }

  color /= weight;
  
  
  float light = ambientOcclusion + max(0.15*dot(normal, vec3(1,1,1)), 0.0);
  
  gl_FragColor = vec4(color.xyz * light, color.w);
}