import { ShaderLib } from "@orillusion/core";
import MyUnLit from "./MyUnLit.wgsl?raw";
import ModelNormal from "./ModelNormal.wgsl?raw";

export function registerShader() {
    ShaderLib.register("MyUnLit", MyUnLit);
    ShaderLib.register("ModelNormal", ModelNormal);
}
