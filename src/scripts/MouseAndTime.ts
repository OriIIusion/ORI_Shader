import { Camera3D, Engine3D, HoverCameraController, MeshRenderer, Object3D, Scene3D, View3D, Color, SolidColorSky, SkyRenderer, PlaneGeometry } from "@orillusion/core";
import { Stats } from "@orillusion/stats";
import { MouseAndTimeMaterial } from "../material/MouseAndTimeMaterial";
import { registerShader } from "../shader/registerShader";

class ScreenCoord {
    async run() {
        //初始化引擎
        await Engine3D.init();
        //注册shader
        registerShader();
        //新建一个场景 添加FPS和灰色背景
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
        controller.setCamera(0, -20, 30);
        //相机添加到场景中
        scene.addChild(cameraObj);

        let mat = new MouseAndTimeMaterial();
        {
            let plane = new Object3D();
            plane.rotationX = 90;
            let mr = plane.addComponent(MeshRenderer);
            mr.geometry = new PlaneGeometry(50, 50);
            mr.material = mat;
            scene.addChild(plane);
        }

        //创建View3D对象
        let view = new View3D();
        //指定渲染的场景和相机
        view.scene = scene;
        view.camera = camera;
        //开始渲染
        Engine3D.startRenderView(view);
    }
}
new ScreenCoord().run();
