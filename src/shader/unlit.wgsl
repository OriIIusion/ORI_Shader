struct GlobalUniform {
    projMat: mat4x4<f32>,
    viewMat: mat4x4<f32>
  };

@group(0) @binding(0)
var<uniform> globalUniform: GlobalUniform;

struct Uniforms {
    matrix : array<mat4x4 < f32>>
}

@group(0) @binding(1)
var<storage, read> models : Uniforms;

@vertex
fn VertMain(@builtin(instance_index) index : u32, @location(auto) position : vec3 < f32>) -> @builtin(position) vec4 < f32> {
    var posClip = globalUniform.projMat * globalUniform.viewMat * models.matrix[u32(index)] * vec4 < f32 > (position.xyz, 1.0);
    return posClip;
}
@fragment
fn FragMain() -> @location(0) vec4 < f32> {
    return vec4(1, 1, 0, 1);
}