
    #include "Common_vert"
    #include "Common_frag"
    #include "UnLit_frag"

    @group(1) @binding(0)
    var baseMapSampler: sampler;
    @group(1) @binding(1)
    var baseMap: texture_2d<f32>;

    fn vert(inputData:VertexAttributes) -> VertexOutput {
        ORI_Vert(inputData) ;
        return ORI_VertexOut ;
    }
// struct GlobalUniform {
//     projMat: mat4x4<f32>,
//     viewMat: mat4x4<f32>
// };
// //获取全局变量 绑定位置为 @group(0) @binding(0)
// @group(0) @binding(0)
// var<uniform> globalUniform: GlobalUniform;

// struct Uniforms {
//     matrix: array<mat4x4<f32>>
// }
// //获取所有的模型矩阵 绑定位置为 @group(0) @binding(1)
// @group(0) @binding(1)
// var<storage, read> models: Uniforms;
//     @vertex
// fn VertMain(@builtin(instance_index) index : u32, @location(0) position : vec3<f32>) -> @builtin(position) vec4<f32> {
//     let posClip = globalUniform.projMat * globalUniform.viewMat * models.matrix[index] * vec4<f32>(position.xyz, 1.0);
//     return posClip;
// }
// struct FragmentOutput {
//             @location(auto) color: vec4<f32>,
//             @location(auto) gBuffer: vec4<f32>,
//             #if USE_OUTDEPTH
//                 @builtin(frag_depth) out_depth: f32
//             #endif
//         };
// @fragment
// fn FragMain() -> @location(0) vec4<f32>{1
//     //return materialUniform.baseColor;
//     return vec4<f32>(1.0, 0.0, 0.0, 1.0);
// }

    

    fn frag(){
        ORI_ShadingInput.BaseColor = vec4<f32>(1,1,1,1) 1;
        UnLit();
    }

