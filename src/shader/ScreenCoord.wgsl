//思考:shader中画布尺寸从哪里来?片元着色器中,如何获取当前像素的屏幕坐标?

//全局变量 本例中要用到画布的宽高尺寸 即windowWidth和windowHeight，但是前面这些属性也需要声明出来，即使暂时不需要使用他们
//因为创建GlobalUniform时就是按照这个顺序添加的 他们的顺序以及数据类型都是不能变的，变了以后数据就乱了。
struct GlobalUniform {
    projMat: mat4x4<f32>,
    viewMat: mat4x4<f32>,
    cameraWorldMatrix: mat4x4<f32>,
    pvMatrixInv : mat4x4<f32>,
    shadowMatrix: array<mat4x4<f32>, 8u>,
    csmShadowBias: vec4<f32>,
    csmMatrix: array<mat4x4<f32>,4u>,
    shadowLights:mat4x4<f32>,
    CameraPos: vec3<f32>,
    frame: f32,
    time: f32,
    delta: f32,
    shadowBias: f32,
    skyExposure: f32,
    renderPassState:f32,
    quadScale: f32,
    hdrExposure: f32,
    renderState_left: i32,
    renderState_right: i32,
    renderState_split: f32,
    mouseX: f32,
    mouseY: f32,
    windowWidth: f32,
    windowHeight: f32
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
    let normalizedScreenPos = screenPos/vec2(globalUniform.windowWidth,globalUniform.windowHeight);
    return vec4(normalizedScreenPos,0,1);
}