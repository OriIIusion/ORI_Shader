//直接复用Orillusion内置shader，GlobalUniform包含了全局变量结构体的定义和绑定，WorldMatrixUniform包含了模型矩阵结构体的定义和绑定。
//下面两行代码等同于我们在前几个shader中开头的对于全局变量和模型矩阵的定义和绑定，提高了代码复用性和简洁性
#include "GlobalUniform"
#include "WorldMatrixUniform"

//定义顶点着色器的输入结构体，这样就可以将多个参数打包到一个结构体中
struct VertexAttributes{
    @builtin(instance_index) index : u32,
    @location(0) position : vec3<f32>  //顶点位置
}

//顶点着色器 仅执行mvp变换
@vertex
fn VertMain(vertex:VertexAttributes) -> @builtin(position) vec4<f32> {
    let ClipPos = globalUniform.projMat * globalUniform.viewMat * models.matrix[vertex.index] * vec4<f32>(vertex.position.xyz, 1.0);
    return ClipPos;
}

//片元着色器 通过@builtin(position)的xy值获取当前像素的屏幕坐标 
//再使用屏幕坐标除以画布的尺寸，使坐标值限制在0~1之间，将处理后的坐标值输出
//如果模型铺满整个屏幕，则左上角为(0，0)黑色   右上角(1，0)红色     左下角(0，1)绿色      右下角(1，1)黄色
@fragment
fn FragMain(@builtin(position) ScreenPos : vec4<f32>) -> @location(0) vec4<f32>{
    let screenPos = ScreenPos.xy;
    let normalizedScreenPos = screenPos/vec2(globalUniform.windowHeight,globalUniform.windowHeight);
    let mousePos = vec2(globalUniform.mouseX,globalUniform.mouseY);
    let normalizedmousePos = mousePos/vec2(globalUniform.windowHeight,globalUniform.windowHeight);
    var time = globalUniform.time/60;
    time = sin(time);
    let distance = distance(normalizedScreenPos,normalizedmousePos);
    if(distance>0.2)
    {
        return vec4(1-time,time,0,1);
    }
    else
    {
        return vec4(1-distance/0.2+time,1-distance/0.2,0,1);
    }
    
}