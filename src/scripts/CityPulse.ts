import { BoxGeometry, Camera3D, Engine3D, HoverCameraController, MeshRenderer, Object3D, Scene3D, View3D, Color, SolidColorSky, SkyRenderer, Vector3, PlaneGeometry, CylinderGeometry } from "@orillusion/core";
import { CityPulseMaterial } from "../material/CityPulseMaterial";
import { registerShader } from "../shader/registerShader";
import { GUI } from "dat.gui";

class CityPulse {
    
    radius: number = 1000;
    origin: Vector3 = new Vector3(0, 0, 0);
    async run() {

        await Engine3D.init();

        registerShader();

        const scene = new Scene3D();
        const sky = scene.addComponent(SkyRenderer);
        sky.map = new SolidColorSky(new Color(0.6, 0.6, 0.6));

        const cameraObj = new Object3D();
        const camera = cameraObj.addComponent(Camera3D);
        camera.perspective(45, window.innerWidth / window.innerHeight, 1, 5000);

        const controller = cameraObj.addComponent(HoverCameraController);
        controller.setCamera(30, -30, 2000);
        controller.maxDistance = 2500;
        controller.rollSmooth = 2.5;
        scene.addChild(cameraObj);        

        const view = new View3D();
        view.scene = scene;
        view.camera = camera;

        Engine3D.startRenderView(view);

        this.initScene(scene)

    }

    initScene(scene: Scene3D) {
        const material = new CityPulseMaterial();
        material.minRange = 0 - (this.origin.z - this.radius);
        material.maxRange = (this.origin.x + this.radius) - (this.origin.z - this.radius);
        material.colorSize = 1000;
        material.fadeSize = 40;
        material.origin = this.origin;
        material.baseColor = new Color(0.8, 0.8, 0.8);

        const ground = new Object3D();
        const groundMr = ground.addComponent(MeshRenderer);
        // groundMr.geometry = new PlaneGeometry(2050, 2050);
        groundMr.geometry = new CylinderGeometry(this.radius + 40, this.radius + 40, 8, 64, 64);
        groundMr.materials = [material, material, material];
        ground.localPosition = this.origin;
        ground.y -= 4;
        scene.addChild(ground);

        const geometry = new BoxGeometry(1, 1, 1);

        for (let i = 0; i < 500; i++) {
            const w = Math.random() * (80 - 20) + 20;
            const h = Math.random() * (180 - 30) + 30;
            const d = Math.random() * (80 - 20) + 20;


            // 生成一个随机角度 (0 到 2 * PI)
            const angle = Math.random() * Math.PI * 2;
            // 生成一个距离圆心的随机半径，使用平方根以确保分布均匀
            const distance = Math.sqrt(Math.random()) * this.radius;
            // 使用极坐标转换为笛卡尔坐标
            const x = distance * Math.cos(angle) + this.origin.x;
            const y = h / 2 + this.origin.y;
            const z = distance * Math.sin(angle) + this.origin.z;

            const obj = new Object3D();
            obj.localScale = obj.localScale.set(w, h, d);
            obj.localPosition = obj.localPosition.set(x, y, z)

            const mr = obj.addComponent(MeshRenderer);
            mr.geometry = geometry;
            mr.material = material;

            scene.addChild(obj);
        }

        this.debug(material);
    }

    debug(material: CityPulseMaterial) {
        const gui = new GUI();
        gui.width = 300;
        const folder = gui.addFolder('CityPulse_ShaderEffect');
        folder.add({animeType:'spread'}, 'animeType', ['spread', 'up']).onChange((e) => {
            material.animeType = e == 'up' ? 0 : 1
        });
        folder.add({spreadOrigin: 'center'}, 'spreadOrigin', ['center', 'corner']).onChange((e) => {
            material.origin = e === 'center' ? this.origin : new Vector3(this.origin.x + this.radius, 0, this.origin.z)
        });
        folder.add(material, 'speed', -1, 1, 0.1);
        folder.add(material, 'windowOpenRatio', 0, 1, 0.01);
        folder.add(material, 'interval', 0, 1500, 1)
        folder.add(material, 'colorSize', 1, 1500, 1)
        folder.add(material, 'fadeSize', 1, 1500, 1)
        folder.addColor({ baseColor: Object.values(material.baseColor).map((v, i) => i === 3 ? v : v * 255) }, 'baseColor').onChange(v => {
            Color.COLOR_0.rgba = v;
            material.baseColor = Color.COLOR_0;
        });
        folder.open();
    }
}

new CityPulse().run();
