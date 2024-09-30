//思考：

#include "GlobalUniform"
#include "WorldMatrixUniform"
#include "MathShader"

struct VertexAttributes {
    @builtin(instance_index) index : u32,
    @location(0) position : vec3<f32>,
    @location(1) normal : vec3<f32>
};
struct VertexOutput {
    @builtin(position) posClip : vec4<f32>,
    @location(0) worldNormal : vec3<f32>
};
struct MaterialUniform {
      
      lightPosition:vec3<f32>,
      baseColor: vec4<f32>,
      lightColor:vec4<f32>,
      ambientColor:vec4<f32>
      
};
//获取材质相关的参数，绑定位置为@group(1) @binding(0)
@group(1) @binding(0)
var<uniform> materialUniform: MaterialUniform;
var<private> vertexOutput: VertexOutput;
var<private> ORI_MATRIX_M: mat4x4<f32>;
var<private> ORI_NORMALMATRIX: mat3x3<f32>;
//顶点着色器 前面应该加上@vertex以表明这就是顶点着色器的入口函数
//函数名可以随便取，但应该和RenderShaderPass中的设置的入口函数名称相同，片元着色器同理。
//以@builtin(instance_index)声明的index可以获得当前模型的索引值，在函数中models.matrix[index]则可以获得本模型的model矩阵
//以@location(0)声明的position可以获得模型的顶点位置
//函数返回应指向@builtin(position) 传递给渲染管线以进行下一步的裁剪工作
//posClip就是裁剪空间坐标，通过模型顶点*mvp矩阵得到，本函数中乘的顺序为p*v*m*pos,顺序不可颠倒。
@vertex
fn VertMain(vertex : VertexAttributes) -> VertexOutput {
    ORI_MATRIX_M = models.matrix[vertex.index];
    ORI_NORMALMATRIX = transpose(inverse(mat3x3<f32>(ORI_MATRIX_M[0].xyz,ORI_MATRIX_M[1].xyz,ORI_MATRIX_M[2].xyz)));
    vertexOutput.posClip = globalUniform.projMat * globalUniform.viewMat * ORI_MATRIX_M * vec4<f32>(vertex.position.xyz, 1.0);
    vertexOutput.worldNormal = ORI_NORMALMATRIX * vertex.normal;
    return vertexOutput;
}

//片元着色器 前面应该加上@fragment以表明这就是片元着色器的入口函数
//函数返回指向@location(0) vec4<f32> 即最终显示在屏幕的颜色
struct FragmentOutput {
            @location(auto) color: vec4<f32>,
            @location(auto) gBuffer: vec4<f32>
        };
var<private> fragmentOutput: FragmentOutput;
@fragment
fn FragMain(fragIn : VertexOutput) -> FragmentOutput{
    let n = normalize(fragIn.worldNormal);
    let l = normalize(materialUniform.lightPosition);
    let ambient = materialUniform.ambientColor.xyz;
    let diffuse = materialUniform.baseColor.xyz * materialUniform.lightColor.xyz * saturate(dot(n,l));
    let color = ambient+diffuse;
    fragmentOutput.color = vec4(color,1);
    return fragmentOutput;
}