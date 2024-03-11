const fs = require("fs");

const isCalledFromCurrentResource = () => {
    return GetInvokingResource() == GetCurrentResourceName();
}

const scanFolder = (path) => {
    if (!isCalledFromCurrentResource()) return;
    const files = [];

    const result = fs.readdirSync(path);
    result.forEach(file => {
        const filePath = path + '/' + file;
        const stat = fs.lstatSync(filePath);

        if (stat.isDirectory()) {
            files.push(...scanFolder(filePath));
        } else if (stat.isFile() && file.endsWith(".lua")) {
            files.push(filePath);
        }
    });

    return files;
}
exports("scanFolder", scanFolder);