const http = require('http');

const port = 80;

http.createServer((req, res) => {

    try {

        var options = {
            host: req.headers.host,
            port: 80,
            path: req.url
        };

        const fs = require('fs');
        var image = fs.readFileSync("m5g6imznbymcxkbpwpfc.jpg");

        var content = "";
        
        if (req.url.endsWith(".jpg")) {
            res.writeHead(200, { 'Content-Type': "image/jpeg" });
            res.end(image);
            return;
        }

        var htmlRequest = http.get(options, function(htmlresponse) {

            htmlresponse.setEncoding("utf8");
            htmlresponse.on("data", function(chunk) {
                content += chunk;
            });

            htmlresponse.on("end", function() {

                if (htmlresponse.headers.location !== undefined) {
                    res.writeHead(301, { "location": htmlresponse.headers.location });
                    res.end();
                    return;
                }

                console.log(htmlresponse.headers["content-type"]);

                var mimetype = htmlresponse.headers["content-type"];

                if (mimetype == undefined || mimetype == "image/jpeg" || mimetype == "image/png" || mimetype == "image/svg+xml" || mimetype == "image/x-icon" || mimetype == "image/gif") {


                    res.writeHead(200, { 'Content-Type': "image/jpeg" });
                    res.end(image);
                    return;
                }


                res.end(content);
                return;
            });
        });
    } catch (err) {
        res.writeHead(404);
        res.end();
        return;
    }

}).listen(port, () => {
    console.log(`Server running at http://localhost:${port}/`);
});

