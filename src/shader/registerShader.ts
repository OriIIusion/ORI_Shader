import { ShaderLib } from "@orillusion/core";
import MyUnLit from "./MyUnLit.wgsl?raw";

export function register() {
    ShaderLib.register("MyUnLit", MyUnLit);
}
