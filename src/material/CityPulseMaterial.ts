import { Material, RenderShaderPass, Shader, Color, Vector3 } from "@orillusion/core";

export class CityPulseMaterial extends Material {
    constructor() {
        super();
        
        let pass = new RenderShaderPass("CityPulse", "CityPulse");
        pass.setShaderEntry(`VertMain`, `FragMain`);

        let shader = new Shader();
        shader.addRenderPass(pass);
        this.shader = shader;
        
        this.setDefault()
    }

    public setDefault() {
        this.setUniformColor(`baseColor`, new Color());
        this.setUniformVector3(`origin`, new Vector3());
        this.setUniformFloat(`windowOpenRatio`, 0.3);
        this.setUniformFloat(`minRange`, 100.0);
        this.setUniformFloat(`maxRange`, 100.0);
        this.setUniformFloat(`interval`, 0.0);
        this.setUniformFloat(`colorSize`, 10.0);
        this.setUniformFloat(`fadeSize`, 100.0);
        this.setUniformFloat(`speed`, 0.1);
        this.setUniformFloat(`animeType`, 1.0);
    }

    get baseColor(): Color {
        return this.shader.getUniformColor("baseColor");
    }
    set baseColor(value: Color) {
        this.shader.setUniformColor("baseColor", value);
    }

    get origin(): Vector3 {
        return this.shader.getUniformVector3("origin");
    }
    set origin(value: Vector3) {
        this.shader.setUniformVector3("origin", value);
    }

    get windowOpenRatio(): number {
        return this.shader.getUniformFloat("windowOpenRatio");
    }
    set windowOpenRatio(value: number) {
        this.shader.setUniformFloat("windowOpenRatio", value);
    }

    get minRange(): number {
        return this.shader.getUniformFloat("minRange");
    }
    set minRange(value: number) {
        this.shader.setUniformFloat("minRange", value);
    }

    get maxRange(): number {
        return this.shader.getUniformFloat("maxRange");
    }
    set maxRange(value: number) {
        this.shader.setUniformFloat("maxRange", value);
    }

    get interval(): number {
        return this.shader.getUniformFloat("interval");
    }
    set interval(value: number) {
        this.shader.setUniformFloat("interval", value);
    }

    get colorSize(): number {
        return this.shader.getUniformFloat("colorSize");
    }
    set colorSize(value: number) {
        this.shader.setUniformFloat("colorSize", value);
    }

    get fadeSize(): number {
        return this.shader.getUniformFloat("fadeSize");
    }
    set fadeSize(value: number) {
        this.shader.setUniformFloat("fadeSize", value);
    }

    get speed(): number {
        return this.shader.getUniformFloat("speed");
    }
    set speed(value: number) {
        this.shader.setUniformFloat("speed", value);
    }

    get animeType(): number {
        return this.shader.getUniformFloat("animeType");
    }
    set animeType(value: number) {
        this.shader.setUniformFloat("animeType", value);
    }
}
