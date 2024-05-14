import { Material, RenderShaderPass, Shader, Color } from "@orillusion/core";

export class MyUnLitMaterial extends Material {
    constructor() {
        super();
        //设置已经注册的shdaer代码
        let pass = new RenderShaderPass("MyUnLit", "MyUnLit");
        //设置顶点着色器和像素着色器的入口函数
        pass.setShaderEntry(`VertMain`, `FragMain`);

        let shader = new Shader();
        shader.addRenderPass(pass);
        this.shader = shader;
        this.baseColor = new Color();
        pass.noticeValueChange();
    }
    /**
     * 获取基础颜色
     */
    get baseColor() {
        return this.shader.getUniformColor("baseColor");
    }
    /**
     * 设置基础颜色
     */
    set baseColor(value: Color) {
        this.shader.setUniformColor("baseColor", value);
    }
}
