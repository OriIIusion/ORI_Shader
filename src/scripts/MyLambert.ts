import { BoxGeometry, Camera3D, Engine3D, HoverCameraController, MeshRenderer, Object3D, Scene3D, View3D, Color, SolidColorSky, SkyRenderer, SphereGeometry, CylinderGeometry, Vector3 } from "@orillusion/core";
import { Stats } from "@orillusion/stats";
import { MyLambertMaterial } from "../material/MyLambertMaterial";
import { registerShader } from "../shader/registerShader";
import dat from "dat.gui";

class MyLambert {
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

        let mat = new MyLambertMaterial();

        let box = new Object3D();
        box.x = -10;
        let mr = box.addComponent(MeshRenderer);
        mr.geometry = new BoxGeometry(5, 5, 5);
        mr.material = mat;
        scene.addChild(box);

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
        const LightInfo = {
            positionX: 6,
            positionY: 5,
            positionZ: 2,
            lightColor: [255, 255, 255]
        };
        mat.baseColor = new Color(1, 1, 1);
        mat.lightPosition = new Vector3(LightInfo.positionX, LightInfo.positionY, LightInfo.positionZ);
        mat.ambientColor = new Color(0.1, 0.1, 0.1);

        mat.lightColor = new Color(LightInfo.lightColor[0] / 255, LightInfo.lightColor[1] / 255, LightInfo.lightColor[2] / 255);

        const gui = new dat.GUI();
        const dirLight = gui.addFolder("DirLight");
        dirLight.add(LightInfo, "positionX", -10, 10, 0.1).onChange((v) => {
            mat.lightPosition = new Vector3(LightInfo.positionX, LightInfo.positionY, LightInfo.positionZ);
        });
        dirLight.add(LightInfo, "positionY", -10, 10, 0.1).onChange((v) => {
            mat.lightPosition = new Vector3(LightInfo.positionX, LightInfo.positionY, LightInfo.positionZ);
        });
        dirLight.add(LightInfo, "positionZ", -10, 10, 0.1).onChange((v) => {
            mat.lightPosition = new Vector3(LightInfo.positionX, LightInfo.positionY, LightInfo.positionZ);
        });
        dirLight.addColor(LightInfo, "lightColor").onChange((v) => {
            mat.lightColor = new Color(LightInfo.lightColor[0] / 255, LightInfo.lightColor[1] / 255, LightInfo.lightColor[2] / 255);
            console.log(mat.lightColor);
        });
        dirLight.open();
        const MatInfo = {
            baseColor: [255, 255, 255],
            ambientColor: [255, 255, 255]
        };
        const material = gui.addFolder("Material");
        material.addColor(MatInfo, "baseColor").onChange(() => {
            mat.baseColor = new Color(MatInfo.baseColor[0] / 255, MatInfo.baseColor[1] / 255, MatInfo.baseColor[2] / 255);
        });
        material.addColor(MatInfo, "ambientColor").onChange(() => {
            mat.ambientColor = new Color(MatInfo.ambientColor[0] / 255, MatInfo.ambientColor[1] / 255, MatInfo.ambientColor[2] / 255);
        });
        material.open();
        //创建View3D对象
        let view = new View3D();
        //指定渲染的场景和相机
        view.scene = scene;
        view.camera = camera;
        //开始渲染
        Engine3D.startRenderView(view);
    }
}
new MyLambert().run();
