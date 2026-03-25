            float gh(float n) {
                return fract(sin(n) * 43758.5453);
            }

            vec4 close_color(vec3 coords_geo, vec3 size_geo) {
                float p = niri_clamped_progress;
                vec2 uv = coords_geo.xy;

                float intensity = p * p;

                float tick = floor(p * 60.0) + niri_random_seed * 1000.0;
                float r1 = gh(tick * 1.13);
                float r2 = gh(tick * 2.37);
                float r3 = gh(tick * 3.71);
                float r4 = gh(tick * 4.19);
                float r5 = gh(tick * 5.53);
                float r6 = gh(tick * 6.91);

                vec2 off_r = vec2(r1 - 0.5, r2 - 0.5) * intensity * 0.15;
                vec2 off_g = vec2(r3 - 0.5, r4 - 0.5) * intensity * 0.15;
                vec2 off_b = vec2(r5 - 0.5, r6 - 0.5) * intensity * 0.15;

                float slice = floor(uv.y * 20.0);
                float slice_offset = (gh(slice + tick) - 0.5) * intensity * 0.12;

                vec2 uv_r = uv + off_r + vec2(slice_offset * 0.7, 0.0);
                vec2 uv_g = uv + off_g + vec2(slice_offset * -0.5, 0.0);
                vec2 uv_b = uv + off_b + vec2(slice_offset * 0.3, 0.0);

                vec3 tc_r = niri_geo_to_tex * vec3(uv_r, 1.0);
                vec3 tc_g = niri_geo_to_tex * vec3(uv_g, 1.0);
                vec3 tc_b = niri_geo_to_tex * vec3(uv_b, 1.0);

                vec4 color;
                color.r = texture2D(niri_tex, tc_r.st).r;
                color.g = texture2D(niri_tex, tc_g.st).g;
                color.b = texture2D(niri_tex, tc_b.st).b;
                color.a = max(max(
                    texture2D(niri_tex, tc_r.st).a,
                    texture2D(niri_tex, tc_g.st).a),
                    texture2D(niri_tex, tc_b.st).a);

                float big_glitch = step(0.8 - p * 0.3, gh(tick * 0.77));
                vec2 shift = vec2((gh(tick * 1.5) - 0.5) * 0.08 * big_glitch * intensity, 0.0);
                vec3 tc_shift = niri_geo_to_tex * vec3(uv + shift, 1.0);
                vec4 shifted = texture2D(niri_tex, tc_shift.st);
                color = mix(color, shifted, big_glitch * intensity * 0.5);

                float scanline = 1.0 - sin(uv.y * size_geo.y * 3.14159) * 0.08 * intensity;
                color.rgb *= scanline;

                float alpha = smoothstep(1.0, 0.6, p);
                return color * alpha;
            }
