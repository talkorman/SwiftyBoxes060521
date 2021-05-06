//
//  SceneViewController.swift
//  Container
//
//  Created by MacBook on 2021/3/25.
//
//*********************************************************************************
//**            This VC class is rendering the graphics                          **
//*********************************************************************************
import UIKit
import SceneKit
import SpriteKit

class SceneViewController: UIViewController{
    var db = Database.shared
       var containerIndex: Int = 0
       var containers: [Container] = []
       let colorArr: [UIColor] = [
           .black, .brown, .cyan, .white, .gray, .green, .orange, .purple, .lightGray, .magenta, .red]
    var colorCollection: [String: UIColor] = [:]
       var colorCounter: Int = 0
    var lookAtPosition: SCNVector3 = SCNVector3(1, 1, 1)
    var currentContainer: Container{
        return containers[containerIndex]
    }
       var listArr: [Package]{ return db.getPackingList()}
       var scnScene: SCNScene!
       var scnView: SCNView!
       var cameraNode: SCNNode!
       var spawnTime: TimeInterval = 0
    //to make sure that the final package was loaded before shifting containers
    var finalPackagePosition: Location{
        guard let pos = scnScene.rootNode.childNodes.last?.position else {
            return Location(x: 0, y: 0, z: 0)
        }
        let x = pos.x
        let y = pos.y
        let z = pos.z
        return Location(x: x, y: y, z: z)
        }

    @IBOutlet weak var processing: UIActivityIndicatorView!
    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var containerNum: UILabel!
    @IBOutlet weak var totalWeight: UILabel!
    @IBOutlet weak var TotalCbm: UILabel!
    @IBOutlet weak var start: UIButton!
    
    @IBOutlet weak var speed: UISlider!
    
    @IBAction func nextContainer(_ sender: UIButton) {
        if containerIndex < containers.count - 1{
            interchangeContainers(1)
        }
    }
    @IBAction func prevContainer(_ sender: UIButton) {
        if containerIndex >= 1{
        interchangeContainers(-1)
        }
    }
    
    func interchangeContainers(_ val: Int){
        //checking if the last package already on the container before shifting containers
               guard let pack = currentContainer.packageArray.last else { return }
               let pos = pack.location
               let loc = Location (x: pos.x - (currentContainer.contDim.l / 2) + (pack.length / 2), y: pos.y + (pack.height / 2), z: pos.z - (currentContainer.contDim.w / 2) + (pack.width / 2))
               if loc == finalPackagePosition{
                 shiftContainers(-100)
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (t) in
                       self.cleanScene()
                      // self.colorCounter = 0
                    //self.currentName = ""
                   }
                    containerIndex += val
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (t) in
                        self.bringEmptyContainer()
                    }
               }
    }
    @objc func shiftContainers(_ distance: Float){
        self.scnScene.rootNode.childNodes.forEach { (node) in
            node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
            node.physicsBody?.applyForce(SCNVector3(0, 0, distance), asImpulse: true)
        }
    }
   
    @objc func bringEmptyContainer(){
        containerNum.text = "Container \(containerIndex + 1)"
        TotalCbm.text = "Loaded CBM \(String(containers[containerIndex].loadedCbm).prefix(5))"
        totalWeight.text = "Loaded weight \(containers[containerIndex].loadedKg)Kg"
        start.isEnabled = false
        containerBuilder(currentContainer.contDim)
        
        scnScene.rootNode.childNodes.forEach { (node) in
            let x = node.position.x
            let y = node.position.y
            let z = node.position.z - 10
            let moveTo = SCNAction.move(to: SCNVector3(x, y, z), duration: 1)
            node.runAction(moveTo)
            loadingProcess()
        }
    }

    func setupView(){
        scnView = (self.view as! SCNView)
        scnView.delegate = self
        scnView.showsStatistics = true
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
        scnView.isPlaying = true
    }
    func setupScene(){
        scnScene = SCNScene(named: "Graphics.scnassets/Loading.scn")
        scnView.scene = scnScene
    }
    func setupCamera(){
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(5, 2, 7)
        cameraNode.look(at: lookAtPosition)
        scnScene.rootNode.addChildNode(cameraNode)
        
    }
    func createBlock(object o: BlockObject, _ material: UIImage) -> SCNNode{
        var geometry: SCNGeometry
        geometry = SCNBox(width: o.w, height: o.h, length: o.l, chamferRadius: 0.01)
        geometry.materials.first?.diffuse.contents = o.color
        
        let geometryNode = SCNNode(geometry: geometry)
        geometryNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        let mat: SCNMaterial = SCNMaterial()
        mat.multiply.contents = material
        geometryNode.geometry?.materials = [mat]
        return geometryNode
    }
    
    //remove all nodes except the floor and the camera
    func cleanScene(){
        for (ix, node) in scnScene.rootNode.childNodes.enumerated(){
            if ix > 1 && node.presentation.position.z < -3{
                node.removeFromParentNode()
            }
        }
    }
 
    func containerBuilder(_ cont: ContType){
        let l = CGFloat(cont.l)
        let w = CGFloat(cont.w)
        let h = CGFloat(cont.h)
        let color:UIColor = UIColor.blue
        let base = BlockObject(l: w, w: l, h: 0.1, x: 0, y: 0, z: 0, color: color, material: nil)
        let sideWall = BlockObject(l: w, w: 0.1, h: h + 0.1, x: 0 - l / 2, y: h / 2, z: 0, color: color, material: nil)
        let backWall = BlockObject(l: 0.1, w: l, h: h + 0.1, x: 0, y: h / 2, z: 0 - w / 2, color: color, material: nil)
        lookAtPosition = SCNVector3(l / 2, 0, w / 2)
        let material = imageWith(name: currentContainer.contDim.size, color: UIColor.blue)!
        let baseNode = createBlock(object: base, material) //container base
        let sideNode = createBlock(object: sideWall, material)// container side wall
        let backNode = createBlock(object: backWall, material)// container backwall
        baseNode.position = SCNVector3(base.x, base.y, base.z + 10)
        sideNode.position = SCNVector3(sideWall.x, sideWall.y, sideWall.z + 10)
        backNode.position = SCNVector3(backWall.x, backWall.y, backWall.z + 10)
        scnScene.rootNode.addChildNode(baseNode)
        scnScene.rootNode.addChildNode(sideNode)
        scnScene.rootNode.addChildNode(backNode)
    }

    func packageBuilder(_ pack: LocatedPackage) -> BlockObject{
        let l = CGFloat(pack.length)
        let w = CGFloat(pack.width)
        let h = CGFloat(pack.height)
        //to change color when package type change
        var color: UIColor{
            guard let color = colorCollection[pack.name] else{
                let color = colorArr[colorCounter % colorArr.count]
                colorCollection[pack.name] = color
                colorCounter += 1
                return color
            }
            return color
        }

        let x = CGFloat(pack.location.x - (currentContainer.contDim.l / 2) + (pack.length / 2))
        let y = CGFloat(pack.location.y + (pack.height / 2))
        let z = CGFloat(pack.location.z - (currentContainer.contDim.w / 2) + (pack.width / 2))
        let material = imageWith(name: pack.name, color: color)!
        let package = BlockObject(l: w, w: l, h: h, x: x, y: y, z: z, color: color, material: material)
        return package
    }
    func loading(_ list: Any){
        if let list = list as? Message{
            showInputDialog(title: list.message, actionHandler: out(text:))
        }
        guard let list = list as? TotalContainers else{
            return
            }
        processing.stopAnimating()
        processing.removeFromSuperview()
        let nonSortContainers = list.h
        if nonSortContainers .isEmpty{
        return
        }
        //sorting to load in a direction from inner area to outer area
        nonSortContainers.forEach { (c) in
            let cd = c.contDim
            let pa = c.packageArray.sorted {$1.location.z > $0.location.z}
            let lc = c.loadedCbm
            let lk = c.loadedKg
            containers.append(Container(contDim: cd, packageArray: pa, loadedCbm: lc, loadedKg: lk))
        }
        start.isEnabled = true
        start.addTarget(self, action: #selector(bringEmptyContainer), for: .touchUpInside)
    }
    func loadingProcess(){
        let packArray = currentContainer.packageArray
        var i = 0
        Timer.scheduledTimer(withTimeInterval: TimeInterval(speed.value / 10), repeats: true) { (timer) in
            let pack = packArray[i]
            let packBlock = self.packageBuilder(pack)
            let packNode = self.createBlock(object: packBlock, packBlock.material!)
                        packNode.position = SCNVector3(0, 5, 10) //position of package before loading
                        self.scnScene.rootNode.addChildNode(packNode)
                        let newPosition = SCNVector3(packBlock.x, packBlock.y, packBlock.z)
            let moveTo = SCNAction.move(to: newPosition, duration: 1)
                        packNode.runAction(moveTo)
            i += 1
            if i >= packArray.count{
                timer.invalidate()
                
                }
                return
            }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if db.getPackingList() .isEmpty{
            showInputDialog(title: "The packing list is empty", subtitle: "add some packages!", actionHandler: { _ in
                self.navigationController?.popViewController(animated: true)
            })
        }
        
        processing.startAnimating()
        start.isEnabled = false
        speed.value = 10
        //if db.logStatus == .loggedOut {return}
        db.reqState = .requestLocations
        db.uploadToCloud("calculate", loading)
        setupView()
        setupScene()
        setupCamera()
        containerIndex = 0
    }

}
extension SceneViewController: SCNSceneRendererDelegate{
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if time > spawnTime{
            spawnTime = time + TimeInterval(Float.random(in: 0.2..<1.5))
        }
       // cleanScene()
    }
}

enum ContainerType: Int{
    case size20fit = 0
    case size40fit = 1
    case size40H = 2
    
    var contArr: ContType {
      let arr =  [
        ContType(l: 2.34, w: 6.01, h: 2.49, maxLoad: 30480, size:"20 fit"),
        ContType(l: 2.34, w: 12.01, h: 2.49, maxLoad: 30400, size: "40 fit"),
        ContType(l: 2.34, w: 12.01, h: 2.60, maxLoad: 30400, size: "40 fit H")
            ]
        return arr[self.rawValue]
    }
}

extension SceneViewController{
    //adding text to the box, frame and color
    func imageWith(name: String?, color backGroundColor: UIColor) -> UIImage? {
         let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
         let nameLabel = UILabel(frame: frame)
        let frameColor: UIColor = backGroundColor == .black ? .white : .black
        nameLabel.layer.borderColor = frameColor.cgColor
        nameLabel.layer.borderWidth = 1.0
         nameLabel.textAlignment = .center
         nameLabel.backgroundColor = backGroundColor
        nameLabel.textColor = backGroundColor == .black ? .white : .black
         nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
         nameLabel.text = name
         UIGraphicsBeginImageContext(frame.size)
          if let currentContext = UIGraphicsGetCurrentContext() {
             nameLabel.layer.render(in: currentContext)
             let nameImage = UIGraphicsGetImageFromCurrentImageContext()
             return nameImage
          }
          return nil
    }
}

extension SceneViewController{
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       
       //AppUtility.lockOrientation(.landscapeLeft)
       AppUtility.lockOrientation(.landscapeLeft, andRotateTo: .landscapeLeft)
       
   }

   override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       
       // Don't forget to reset when view is being removed
       AppUtility.lockOrientation(.all)
   }
    
    override var shouldAutorotate: Bool{
        return false
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .landscapeLeft
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .landscapeLeft
    }
}

