#include "GlobalUniform"
// #include "MathShader" //  GlobalUniform 已引入 src/assets/shader/math/MathShader.ts

// 定义模型矩阵的结构体和绑定
struct Uniforms {
    matrix: array<mat4x4<f32>>,
};
@group(0) @binding(1) var<storage, read> models: Uniforms;

// 定义材质相关的uniform
struct MaterialUniform {
    baseColor: vec4<f32>,
    origin: vec3<f32>, // vec类型需要在前面定义，测试末尾定义无效
    windowOpenRatio: f32,
    minRange: f32,
    maxRange: f32,
    interval: f32,
    colorSize: f32,
    fadeSize: f32,
    speed: f32,
    animeType: f32, // 不支持bool?
};
@group(1) @binding(0) var<uniform> materialUniform: MaterialUniform;

// 顶点着色器输入输出
struct VertexAttributes {
    @builtin(instance_index) index: u32, // 顶点索引
    @location(0) position: vec3<f32>,  // 顶点位置
    @location(1) normal: vec3<f32>,    // 顶点法线
    @location(2) uv: vec2<f32>,        // 顶点UV
};
struct VertexOutput {
    @builtin(position) ClipPos: vec4<f32>,
    @location(0) vWorldPos: vec3<f32>,
    @location(1) vPosition: vec3<f32>,
    @location(2) vNormal: vec3<f32>,
    @location(3) vUv: vec2<f32>,
};

// 顶点着色器主体
@vertex
fn VertMain(vertex: VertexAttributes) -> VertexOutput {
    var output: VertexOutput;
    let modelMatrix = models.matrix[vertex.index];
    let worldPosition = modelMatrix * vec4<f32>(vertex.position, 1.0);

    output.vWorldPos = worldPosition.xyz;
    output.vPosition = vertex.position;
    output.vNormal = vertex.normal;
    output.vUv = vertex.uv;

    output.ClipPos = globalUniform.projMat * globalUniform.viewMat * worldPosition;
    return output;
}

struct FragmentOutput {
    @location(auto) color: vec4<f32>,
    @location(auto) gBuffer: vec4<f32>
};

fn mod_f32(a: f32, b: f32) -> f32 {
    return a - b * floor(a / b);
}

// 新增的全局 uniform 控制窗户开启比例
// @group(1) @binding(1) var<uniform> windowOpenRatio: f32;

fn hash(val: vec2<f32>) -> f32 {
    let dotProduct = dot(val, vec2<f32>(12.9898, 78.233));
    return fract(sin(dotProduct) * 43758.5453);
}

fn modify_window_colors(color: ptr<function, vec3<f32>>,  baseColor: ptr<function, vec3<f32>>, fragIn: VertexOutput) {

    let vNormal = fragIn.vNormal;
    let vWorldPos = fragIn.vWorldPos;

    let windowWidth: f32 = 3.0;
    let windowHeight: f32 = 3.0;
    let windowSpacing: f32 = 6.0;
    let floorHeight: f32 = windowHeight + windowSpacing;
    let edgeBlur: f32 = 0.6;
    let windowColor: vec3<f32> = vec3<f32>(1.0, 1.0, 1.0);

    let isFront = abs(vNormal.z - 1.0) < 0.001;
    let isBack = abs(vNormal.z + 1.0) < 0.001;
    let isLeft = abs(vNormal.x - 1.0) < 0.001;
    let isRight = abs(vNormal.x + 1.0) < 0.001;

    if (isFront || isBack) {
        let xMod = mod_f32(vWorldPos.x, windowWidth + windowSpacing);
        let yMod = mod_f32(vWorldPos.y, windowHeight + floorHeight);

        if (xMod < windowWidth && yMod < windowHeight) {
            // 为当前窗户生成随机值
            let windowPos = vec2<f32>(floor(vWorldPos.x / (windowWidth + windowSpacing)), floor(vWorldPos.y / floorHeight));

            let randVal = ARand21(windowPos);

            // 根据 windowOpenRatio 控制窗户显示
            if (randVal < materialUniform.windowOpenRatio) {
                
                // 计算窗户边缘的渐变
                let xEdgeDist = min(xMod, windowWidth - xMod);
                let yEdgeDist = min(yMod, windowHeight - yMod);
                let edgeFactor = smoothstep(0.0, edgeBlur, min(xEdgeDist, yEdgeDist));

                *color = mix(*color, windowColor, edgeFactor);
                *baseColor = mix(*baseColor, windowColor, edgeFactor);
            }
        }
    } else if (isLeft || isRight) {
        let zMod = mod_f32(vWorldPos.z, windowWidth + windowSpacing);
        let yMod = mod_f32(vWorldPos.y, windowHeight + floorHeight);

        if (zMod < windowWidth && yMod < windowHeight) {

            let windowPos = vec2<f32>(floor(vWorldPos.z / (windowWidth + windowSpacing)), floor(vWorldPos.y / floorHeight));

            let randVal = ARand21(windowPos);

            if (randVal < materialUniform.windowOpenRatio) {
                
                let zEdgeDist = min(zMod, windowWidth - zMod);
                let yEdgeDist = min(yMod, windowHeight - yMod);
                let edgeFactor = smoothstep(0.0, edgeBlur, min(zEdgeDist, yEdgeDist));

                *color = mix(*color, windowColor, edgeFactor);
                *baseColor = mix(*baseColor, windowColor, edgeFactor);
            }
        }
    }
}

@fragment
fn FragMain(fragIn: VertexOutput) -> FragmentOutput {
    var fragOutput: FragmentOutput;

    // 基础颜色
    var baseColor = materialUniform.baseColor.xyz;

    // 根据位置范围规范化的顶点颜色
    let red = clamp((fragIn.vWorldPos.x + materialUniform.minRange) / materialUniform.maxRange, 0.0, 1.0);
    let green = clamp((fragIn.vWorldPos.y + 300) / 600, 0.0, 1.0);
    let blue = clamp((fragIn.vWorldPos.z + materialUniform.minRange) / materialUniform.maxRange, 0.0, 1.0);
    var color = vec3<f32>(red, green, blue);


    // 直接在函数内部通过指针修改窗户颜色，包括顶点颜色与背景色
    if(materialUniform.windowOpenRatio > 0.0){
        modify_window_colors(&color, &baseColor, fragIn);
    }

    let windowSize = vec2(globalUniform.windowWidth);
    let normalizedScreenPos = fragIn.ClipPos.xy / windowSize;
    let mousePos = vec2(globalUniform.mouseX, globalUniform.mouseY);
    let normalizedmousePos = mousePos / windowSize;
    if(distance(normalizedScreenPos, normalizedmousePos) < 0.02) {
        fragOutput.color = vec4(color,1.0);
        return fragOutput;
    }

    // 动画模式，根据距离计算的扩散效果，或基于顶点高度的向上波动效果
    var dir: f32;
    if (materialUniform.animeType == 1.0) {
        dir = distance(fragIn.vWorldPos.xz, materialUniform.origin.xz);
    } else {
        dir = fragIn.vWorldPos.y;
    }
    
    let fade_size = materialUniform.fadeSize;
    let color_size = materialUniform.colorSize;
    let intervalRange = color_size + materialUniform.interval + (fade_size * 2.0);
    let currentHeight = mod_f32(dir - globalUniform.time * materialUniform.speed, intervalRange);

    // 渐变区域
    if (currentHeight < fade_size) {
        color = mix(baseColor, color, smoothstep(0.0, fade_size, currentHeight));
    } else if (currentHeight > color_size + fade_size) {
        color = mix(color, baseColor, smoothstep(0.0, fade_size, currentHeight - color_size - fade_size));
    }

    fragOutput.color = vec4<f32>(color, 1.0);
    return fragOutput;
}
