        vec4 close_color(vec3 coords_geo, vec3 size_geo) {
            float p = 1.0 - niri_clamped_progress;
            vec2 uv = coords_geo.xy;

            float dist = length(uv - 0.5) * 2.0;
            float start_delay = dist * 0.6;

            float t = clamp((p - start_delay) / (1.0 - start_delay), 0.0, 1.0);
            float strong_t = pow(t, 2.5);
            if (p < start_delay) return vec4(0.0);

            vec2 target = uv;
            vec2 center = vec2(0.5);
            vec2 from_center = uv - center;
            vec2 spawn = center + from_center * 0.0;

            vec2 render_pos = mix(spawn, target, strong_t);

            vec3 tex_coords = niri_geo_to_tex * vec3(render_pos, 1.0);
            vec4 color = texture2D(niri_tex, tex_coords.st);

            return color * t;
