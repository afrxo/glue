// upload.js - Upload Glue to the Roblox Library

const fs = require('fs')
const noblox = require('noblox.js')

async function main () {
    noblox.uploadModel(fs.readFileSync("Glue.rbxm"), {
        name: "Glue",
        description: "An opinionated game framework.",
        copyLocked: false,
        allowComments: true
    }, 9698087811).then(() => {
        console.log("Uploaded Glue.rbxm")
    }).catch((reason) => {
        console.log(reason)
    })
}

noblox.setCookie(process.argv[2]).then(main)