//全局变量
struct GlobalUniform {
    projMat: mat4x4<f32>,
    viewMat: mat4x4<f32>
};
@group(0) @binding(0)
var<uniform> globalUniform: GlobalUniform;

struct Uniforms {
    matrix: array<mat4x4<f32>>
}
//模型矩阵
@group(0) @binding(1)
var<storage, read> models: Uniforms;

//定义顶点着色器的输入结构体，这样就可以将多个参数打包到一个结构体中
struct VertexAttributes{
    @builtin(instance_index) index : u32,
    @location(0) position : vec3<f32>,
    @location(1) normal : vec3<f32>
}
//定义顶点着色器的输出结构体，同时也是片元着色器的输入结构体,当需要顶点着色器给片元着色器传递参数时使用,本例中将顶点的法线传递给片元着色器
struct VertexOutput{
    @builtin(position) ClipPos : vec4<f32>,
    @location(0) normal : vec3<f32>
}
var<private> vertexOut: VertexOutput;
//顶点着色器 
@vertex
fn VertMain(vertex:VertexAttributes) -> VertexOutput {
    vertexOut.ClipPos = globalUniform.projMat * globalUniform.viewMat * models.matrix[vertex.index] * vec4<f32>(vertex.position.xyz, 1.0);
    vertexOut.normal = vertex.normal;
    return vertexOut;
}

//片元着色器 将顶点着色器传过来的法线值输出
@fragment
fn FragMain(fragin:VertexOutput) -> @location(0) vec4<f32>{
    return vec4(fragin.normal,1);
}