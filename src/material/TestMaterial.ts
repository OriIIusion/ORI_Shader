import { Engine3D, Texture, Color, Material, UnLitShader, Shader, RenderShaderPass, Vector4 } from "@orillusion/core";
/**
 * Unlit Mateiral
 * A non glossy surface material without specular highlights.
 * @group Material
 */
export class TestMaterial extends Material {
    /**
     * @constructor
     */
    constructor() {
        super();
        // this.shader = new UnLitShader();
        let colorShader = new RenderShaderPass("TestUnLit", "TestUnLit");
        colorShader.setShaderEntry(`VertMain`, `FragMain`);
        let shader = new Shader();
        shader.addRenderPass(colorShader);
        this.shader = shader;
        // this.baseColor = new Color(1, 1, 1, 1);
        // default value
        // this.baseMap = Engine3D.res.whiteTexture;

        this.setUniformVector4(`transformUV1`, new Vector4(0, 0, 1, 1));
        this.setUniformVector4(`transformUV2`, new Vector4(0, 0, 1, 1));
        this.setUniformColor(`baseColor`, new Color());
        this.setUniformFloat(`alphaCutoff`, 0.0);
        // colorShader.noticeValueChange();
    }
}
