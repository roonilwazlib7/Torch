/*

    A simple utility that converts XML texture atlases of the form:
    <TextureAtlas imagePath="sheet.png">
    	<SubTexture name="simpleExplosion00.png" x="0" y="0" width="186" height="186"/>
    	<SubTexture name="simpleExplosion01.png" x="155" y="345" width="152" height="150"/>
    	<SubTexture name="simpleExplosion08.png" x="0" y="186" width="159" height="159"/>
    </TextureAtlas>
    Into valid torch texture atlas json
*/
var fs = require("fs"),
    program = require("commander"),
    parseXmlString = require('xml2js').parseString;

program
    .version('1.0.0')
    .option('-f, --file [source]', "TextureAtlas xml file")
    .parse(process.argv);

xml = fs.readFileSync( program.file )
xmlDoc = {}
jsonDoc = { textures: {} }

function ParseTextures(textures)
{
    for (var i = 0; i < textures.length; i++)
    {
        var tex = textures[i]["$"];
        jsonDoc.textures[ tex.name.split(".")[0] ] = {
            x: tex.x,
            y: tex.y,
            width: tex.width,
            height: tex.height
        };
    }
}

parseXmlString(xml, function (err, result) {
    xmlDoc = result;
    ParseTextures( xmlDoc.TextureAtlas.SubTexture );
    fs.writeFileSync( program.file.split(".")[0] + ".json", JSON.stringify(jsonDoc, null, 4) );
});
