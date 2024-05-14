import { BoxGeometry, Camera3D, Engine3D, HoverCameraController, MeshRenderer, Object3D, Scene3D, View3D, Color, SolidColorSky, SkyRenderer, SphereGeometry, CylinderGeometry } from "@orillusion/core";
import { Stats } from "@orillusion/stats";
import { ModelNormalMaterial } from "../material/ModelNormalMaterial";
import { registerShader } from "../shader/registerShader";

class MyUnLit {
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
        controller.setCamera(45, -20, 30);
        //相机添加到场景中
        scene.addChild(cameraObj);

        let mat = new ModelNormalMaterial();
        {
            let box = new Object3D();
            box.x = -10;
            let mr = box.addComponent(MeshRenderer);
            mr.geometry = new BoxGeometry(5, 5, 5);
            mr.material = mat;
            scene.addChild(box);
        }
        {
            let sphere = new Object3D();
            sphere.x = 10;
            let mr = sphere.addComponent(MeshRenderer);
            mr.geometry = new SphereGeometry(3, 20, 20);
            mr.material = mat;
            scene.addChild(sphere);
        }
        {
            let cylinder = new Object3D();
            let mr = cylinder.addComponent(MeshRenderer);
            mr.geometry = new CylinderGeometry(2, 3, 5, 20, 5);
            mr.materials = [mat, mat, mat];
            scene.addChild(cylinder);
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
new MyUnLit().run();
