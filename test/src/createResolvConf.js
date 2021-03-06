const fs = require('fs');

let main = function () {
    //node createResolveConf.js $(docker inspect bridge)
    let inspect = JSON.parse(process.argv[2]);
    let bridge = inspect[0]["NetworkSettings"]["Networks"]["databox-system-net"]["IPAddress"];
    let conf = [
        "#Generated by databox - " + (new Date()).toString(),
        "nameserver 127.0.0.11",
        "nameserver " + bridge,
        "options ndots 0",
        ""
    ];

    let path = "./.resolv.conf";
    let content = conf.join('\n');

    fs.writeFileSync(path, content);
    return;
};

main();