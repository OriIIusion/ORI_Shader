import { Material, RenderShaderPass, Shader } from "@orillusion/core";

export class ModelNormalMaterial extends Material {
    constructor() {
        super();
        //设置已经注册的shdaer代码
        let pass = new RenderShaderPass("ModelNormal", "ModelNormal");
        //设置顶点着色器和像素着色器的入口函数
        pass.setShaderEntry(`VertMain`, `FragMain`);

        let shader = new Shader();
        shader.addRenderPass(pass);
        this.shader = shader;

        pass.noticeValueChange();
    }
}
