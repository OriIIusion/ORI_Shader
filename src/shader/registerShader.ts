import { ShaderLib } from "@orillusion/core";
import MyUnLit from "./MyUnLit.wgsl?raw";
import ModelNormal from "./ModelNormal.wgsl?raw";
import ScreenCoord from "./ScreenCoord.wgsl?raw";
import MouseAndTime from "./MouseAndTime.wgsl?raw";
import MyLambert from "./MyLambert.wgsl?raw";

export function registerShader() {
    ShaderLib.register("MyUnLit", MyUnLit);
    ShaderLib.register("ModelNormal", ModelNormal);
    ShaderLib.register("ScreenCoord", ScreenCoord);
    ShaderLib.register("MouseAndTime", MouseAndTime);
    ShaderLib.register("MyLambert", MyLambert);
}
