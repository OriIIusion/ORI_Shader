//思考:shader中,#include "XXX"什么意思？鼠标的屏幕坐标如何获取？怎样获得一个随时间不断增长的数？

//直接复用Orillusion内置shader，GlobalUniform包含了全局变量结构体的定义和绑定，WorldMatrixUniform包含了模型矩阵结构体的定义和绑定。
//下面两行代码等同于我们在前几个shader中开头的对于全局变量和模型矩阵的定义和绑定，提高了代码复用性和简洁性
//另外，自己定义GlobalUniform结构体容易把属性的顺序与数据类型写错，如果自己定义的GlobalUniform与内置GlobalUniform不一样，我们获取到的数据就可能是错的
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

//片元着色器
@fragment
fn FragMain(@builtin(position) ScreenPos : vec4<f32>) -> @location(0) vec4<f32>{
    //获取该像素的屏幕坐标并除以画布尺寸的宽度，就可得到0~1范围内的像素坐标
    //同时除以画布尺寸的宽度，像素在x和y方向的距离是一样的，便于后面画圆
    let screenPos = ScreenPos.xy;
    let normalizedScreenPos = screenPos/vec2(globalUniform.windowWidth,globalUniform.windowWidth);
    //获取鼠标的屏幕坐标并除以画布尺寸的宽度，就可得到0~1范围内的鼠标坐标
    let mousePos = vec2(globalUniform.mouseX,globalUniform.mouseY);
    let normalizedmousePos = mousePos/vec2(globalUniform.windowWidth,globalUniform.windowWidth);
    //计算当前像素点与鼠标点的距离
    let distance = distance(normalizedScreenPos,normalizedmousePos);
    //globalUniform.frame每过一帧，该值+1，这里获取到的time是一个随时间不断增长的数值。
    let time = globalUniform.frame/1000;
    //不好解释，总体来说就是判断该像素与鼠标的距离，每0.02为一段，形成交替的颜色，再加上time的变换，最终形成一个变化的颜色交替的圆。
    let num = i32(floor((distance-time)/0.02));
    //奇数一个色 偶数一个色
    if(num%2==0)
    {
        return vec4(0.8,0.3,0.1,1);
    }
    else
    {
        return vec4(0.6,0.7,0.2,1);
    }
}