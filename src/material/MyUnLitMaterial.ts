import { Material, RenderShaderPass, Shader, Color, GPUPrimitiveTopology, Vector4 } from "@orillusion/core";

export class MyUnLitMaterial extends Material {
    constructor() {
        super();
        let pass = new RenderShaderPass("MyUnLit", "MyUnLit");
        pass.setShaderEntry(`VertMain`, `FragMain`);

        let shader = new Shader();
        shader.addRenderPass(pass);
        this.shader = shader;
        shader.setUniformColor(`baseColor1`, new Color(0, 1, 0, 1));
        shader.setUniformFloat("test", 0);
        //pass.noticeValueChange();
    }
}
