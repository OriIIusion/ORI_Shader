import { AtmosphericComponent, BoxGeometry, Camera3D, ComponentBase, DirectLight, Engine3D, HoverCameraController, LitMaterial, Material, MeshRenderer, Object3D, RenderShaderPass, Scene3D, Shader, ShaderLib, View3D, UnLitMaterial, Color, Vector4, Texture, BlendMode, GPUCullMode, Vector2, SolidColorSky, SkyRenderer } from "@orillusion/core";
import { Stats } from "@orillusion/stats";
import { MyUnLitMaterial } from "../material/materials";
import { register } from "../shader/registerShader";

export default class demo {
    async run() {
        //初始化引擎
        await Engine3D.init();
        register();
        //新建一个场景 添加FPS
        let scene = new Scene3D();
        const sky = scene.addComponent(SkyRenderer);
        sky.map = new SolidColorSky(new Color(0.3, 0.3, 0.3));
        scene.addComponent(Stats);

        //新建相机
        let cameraObj = new Object3D();
        let camera = cameraObj.addComponent(Camera3D);
        //设置相机参数
        camera.perspective(60, window.innerWidth / window.innerHeight, 1, 5000);
        //设置相机控制器
        let controller = cameraObj.addComponent(HoverCameraController);
        controller.setCamera(45, -20, 30);
        //相机添加到场景中
        scene.addChild(cameraObj);

        //新建一个Box并添加网格渲染组件
        let boxObj = new Object3D();
        let mr = boxObj.addComponent(MeshRenderer);
        //设置网格渲染组件的几何形状和材质
        mr.geometry = new BoxGeometry(5, 5, 5);
        let mat = new MyUnLitMaterial();

        mr.material = mat;

        //将物体添加到场景中
        scene.addChild(boxObj);

        //创建View3D对象
        let view = new View3D();
        //指定渲染的场景和相机
        view.scene = scene;
        view.camera = camera;
        //开始渲染
        Engine3D.startRenderView(view);
    }
}
