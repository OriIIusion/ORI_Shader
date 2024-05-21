import { Material, RenderShaderPass, Shader, Color, Vector3 } from "@orillusion/core";

export class MyLambertMaterial extends Material {
    constructor() {
        super();
        //设置已经注册的shader代码
        let pass = new RenderShaderPass("MyLambert", "MyLambert");
        //设置顶点着色器和像素着色器的入口函数
        pass.setShaderEntry(`VertMain`, `FragMain`);
        let shader = new Shader();
        shader.addRenderPass(pass);
        this.shader = shader;
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
    /**
     * 获取环境光颜色
     */
    get ambientColor() {
        return this.shader.getUniformColor("ambientColor");
    }
    /**
     * 设置环境光颜色
     */
    set ambientColor(value: Color) {
        this.shader.setUniformColor("ambientColor", value);
    }
    /**
     * 获取灯光颜色
     */
    get lightColor() {
        return this.shader.getUniformColor("lightColor");
    }
    /**
     * 设置灯光颜色
     */
    set lightColor(value: Color) {
        this.shader.setUniformColor("lightColor", value);
    }
    /**
     * 获取灯光位置
     */
    get lightPosition() {
        return this.shader.getUniformVector3("lightPosition");
    }
    /**
     * 设置灯光位置
     */
    set lightPosition(value: Vector3) {
        this.shader.setUniformVector3("lightPosition", value);
    }
}
