import { ShaderLib } from "@orillusion/core";
import MyUnLit from "./MyUnLit.wgsl?raw";

export function registerShader() {
    ShaderLib.register("MyUnLit", MyUnLit);
}
