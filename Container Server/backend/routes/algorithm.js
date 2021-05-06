
/**************************************************************************************************
 The core code of the loading calculation algoritm. I removed the main part of the code.
 **************************************************************************************************/
'use strict';
const express = require("express");
const router = express.Router();
const checkAuth = require("../middleware/check-auth");

var containers_list = [],
    table = [],
    contType = "20 fit",
    c_container, //the default container
    container_array_swift = [],
    change_container;
    class ContDimSwift{
        constructor(l, w, h, maxLoad, size){
            this.l = l;
            this.w = w;
            this.h = h;
            this.maxLoad = maxLoad;
            this.size = size;
        }
    }
    class ContSwift{
        constructor(cont_dim, package_array, loaded_cbm, loaded_kg){
            this.cont_dim = cont_dim;
            this.package_array = package_array;
            this.loaded_cbm = loaded_cbm;
            this.loaded_kg = loaded_kg;
        }
    };
    class LocatedPackagedSwift{
        constructor(item, name, qty, length, width, height, weight, cbm, locate, location){
            this.item = item;
            this.name = name;
            this.qty = qty;
            this.length = length;
            this.width = width;
            this.height = height;
            this.weight = weight;
            this.cbm = cbm;
            this.locate = locate;
            this.location = location; 
        }
    };
    class PackageLocationSwift{
        constructor(x, y, z, xc, yc, zc){
            this.x = x;
            this.y = y;
            this.z = z;
            this.xc = xc;
            this.yc = yc;
            this.zc = zc;
        }
    };
    const loading = function(c){
        container_array_swift = [];
        for (let i = 0; i < c.length; i++){
        let l =  c[i].cont_dim.l / 100;
        let w = c[i].cont_dim.w / 100;
        let h = c[i].cont_dim.h / 100;
        let maxLoad = c[i].cont_dim.maxLoad;
        let size = c[i].cont_dim.size;
        const cont_dim = new ContDimSwift(l, w, h, maxLoad, size);
        const loaded_cbm = c[i].loaded_cbm;
        const loaded_kg = c[i].loaded_kg;
        const container = new ContSwift(cont_dim, [], loaded_cbm, loaded_kg);
        container.package_array = [];
        for (let j = 0; j < c[i].package_array.length; j++){
        let item = c[i].package_array[j].item;
        let name = c[i].package_array[j].name;
        let qty =  c[i].package_array[j].qty;  
        let length = c[i].package_array[j].length / 100;
        let width = c[i].package_array[j].width / 100;
        let height = c[i].package_array[j].height / 100;
        let weight = c[i].package_array[j].weight;
        let cbm = c[i].package_array[j].cbm;
        let x = c[i].package_array[j].location.x / 100;
        let y = c[i].package_array[j].location.y / 100;
        let z = c[i].package_array[j].location.z / 100;
        let xc = c[i].package_array[j].location.xc / 100;
        let yc = c[i].package_array[j].location.yc / 100;
        let zc = c[i].package_array[j].location.zc / 100; 
        let locate = c[i].package_array[j].locate;  
        let location = new PackageLocationSwift(x, y, z, xc, yc, zc);
        let locatedPackage = new LocatedPackagedSwift(item, name, qty, length, width, height, weight, cbm, locate, location);
        container.package_array.push(locatedPackage);
        };
        container_array_swift.push(container);
    };
    console.log("\n Array after hamchala: \n");
    for (let i = 0; i < container_array_swift.length; i++){
    console.log("\n container " + i + "\n" + JSON.stringify(container_array_swift[i]));
    };
};
router.post("", checkAuth, (req, res, next) => {
    let contype = req.body.container;  
    let table = req.body.packingList;
    c_container = cont_arr.filter(c => {return c.size === contype});
    change_container = JSON.parse(JSON.stringify(c_container));
    hamchala(table, loading);
    res.json({
           h: container_array_swift
        });
    });
    
    
    
    //table.length = 0;
    //containers_list.length = 0;
    // for (let item in req.body.packingList) {
    //     table.push(req.body.packingList[item])
    // };
  
    
//     const result = containers_list;
//     console.log("List: " + JSON.stringify(result) );
        
//         containers_list.length = 0;
// };

var packing_list = [],
    pack_balance = [];
const cont_arr = [{ l: 234, w: 601, h: 249, maxLoad: 30480, size: '20 ft' },
    { l: 234, w: 1201, h: 249, maxLoad: 30400, size: '40 ft' },
    { l: 234, w: 1201, h: 260, maxLoad: 30400, size: '40 ft H' }
];


//build an array from the table data
var create_packingList = function(t) {
    console.log('arrived packing list:', t);
    var items = t.length,
        pl = [],
        row = [],
        ind = 0,    //added
        index;
    for (let j = 0; j < items; j++) {
        index = t[j].qty;
        for (let i = 1; i <= index; i++) {
            row = t[j];
            row.item = ind; //added
            row.qty = 1;
            pl.push(new Package(row))
            ind++;  //added
        }
    }
    return pl;
}


/*******************************************************************************************************
 From here all the lines related to the loading calculation algoritm were deleted for commercial purpose.
 ********************************************************************************************************/





var hamchala = function(t, loading) {
    var containers = [],
        total_cbm = 0,
        total_kg = 0,
        cont_index = 0,
        dim_index = 0,
        bal_cbm = 0;
        pack_balance = [];
        packing_list = [];
        containers = [];
    packing_list = create_packingList(t);
    for (let i = 0; i < packing_list.length; i++) {
        total_cbm += packing_list[i].cbm;
        total_kg += packing_list[i].weight;
    }
    bal_cbm = total_cbm;
    loadingLoop(packing_list);
    function loadingLoop(list){
        if (bal_cbm < 33) { 
            dim_index = 0 ;
        } else if (bal_cbm > 33 && bal_cbm < 69) { 
            dim_index = 1; } 
            else{ 
                dim_index = 2;
            };
        let contTemp = new Container(cont_arr[dim_index]);     
        pack_balance = [];
        contTemp.loadingProcess(list);
        console.log("cont temp: " + JSON.stringify(contTemp));
        containers.push(contTemp);
        bal_cbm -= contTemp.loaded_cbm;
        if(bal_cbm <= 0){return} 
        loadingLoop(pack_balance);
    };
    for (let c in containers){
    console.log("\n list of container: " + JSON.stringify(c));
    };
    loading(containers);
}
module.exports = router