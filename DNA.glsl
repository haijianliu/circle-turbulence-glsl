
#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359

float smoother = 0.001;
float rDot;
float lLength;
float lineBord = 0.001;
float lGray = 0.3;
float dot1;
float dot2;
float c;

float round(in vec2 pos, in float rDot){
	return 1.0 - smoothstep(rDot, rDot + smoother, length(pos));
}

float line(in vec2 pos, in float l){
	return (smoothstep(-lLength - smoother, -lLength, pos.x) - smoothstep(lLength, lLength + smoother, pos.x)) * (smoothstep(-lineBord - smoother, -lineBord, pos.y) - smoothstep(lineBord, lineBord + smoother, pos.y));
}

float twoDots(in vec2 pos, float y, float delay){
	lLength = 0.05;
	rDot = 0.01;
	lLength *= sin(0.5 * PI * (iGlobalTime + delay));
	pos -= vec2(lLength, -y);
	dot1 = round(pos, rDot * (1.0 + 0.2 * cos(0.5 * PI * (iGlobalTime + delay))));
	pos += vec2(lLength + lLength, 0.0);
	dot2 = round(pos, rDot * (1.0 + 0.2 * cos(0.5 * PI * (iGlobalTime + 2.0 + delay))));
	pos -= vec2(lLength, 0.0);
	return abs(lGray * line(pos, lLength)) + dot1 + dot2;
}

float chain(in vec2 pos,float delay){
	c = 0.0;
	for(float i = 0.0;  i< 10.0; i++) {
		c += twoDots(pos, 0.25 - 0.05 * i, 0.1 * i + delay);
	}
	return c;
}

void main(){
	vec2 st = gl_FragCoord.xy / iResolution.xy;
	st.y *= iResolution.y / iResolution.x;

	vec2 pos = vec2(0.5, 0.5) - st;

	vec3 color = vec3(chain(pos, 0.0), chain(pos, 0.1), chain(pos, 0.10));

	gl_FragColor = vec4(color, 1.0);
}
