//全局变量 projMat是投影矩阵 viewMat是视图矩阵
struct GlobalUniform {
    projMat: mat4x4<f32>,
    viewMat: mat4x4<f32>
};
//获取全局变量 绑定位置为 @group(0) @binding(0)
@group(0) @binding(0)
var<uniform> globalUniform: GlobalUniform;

struct Uniforms {
    matrix: array<mat4x4 < f32>>
}
//获取所有的模型矩阵 绑定位置为 @group(0) @binding(1)
@group(0) @binding(1)
var<storage, read> models: Uniforms;

struct MaterialUniform {
      //transformUV1:vec4<f32>,
      //transformUV2:vec4<f32>,
      baseColor1: vec4<f32>,
      test: f32
      //alphaCutoff: f32
    };
@group(1) @binding(0)
var<uniform> materialUniform: MaterialUniform;
//顶点着色器 前面应该加上@vertex以表明这就是顶点着色器的入口函数
//函数名可以随便取，但应该和RenderShaderPass中的设置的入口函数名称相同，像素/片元着色器同理。
//以@builtin(instance_index)声明的index可以获得当前模型的索引值，在函数中models.matrix[index]则可以获得本模型的model矩阵
//以@location(0)声明的position可以获得模型的顶点位置
//函数返回应指向@builtin(position) 以传递给像素/片元着色器
//posClip就是裁剪空间坐标，通过模型顶点*mvp矩阵得到，本函数中乘的顺序为p*v*m*pos,顺序不可颠倒。
@vertex
fn VertMain(@builtin(instance_index) index : u32,@location(0) position : vec3<f32>) -> @builtin(position) vec4<f32> {
    let posClip = globalUniform.projMat * globalUniform.viewMat * models.matrix[index] * vec4<f32>(position.xyz, 1.0);
    return posClip;
}


//像素/片元着色器 前面应该加上@fragment以表明这就是像素/片元着色器的入口函数

@fragment
fn FragMain() -> @location(0) vec4 < f32> {
    var uni = materialUniform.baseColor1;
    return uni;
}