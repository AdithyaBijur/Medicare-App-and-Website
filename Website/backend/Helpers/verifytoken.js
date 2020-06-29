const jwt = require('jsonwebtoken');
const config = require('../config');
module.exports = function (req, res, next) {

    const bearerHeader = req.headers['authorization'];
    // Check if bearer is undefined
    // console.log(bearerHeader)
    if (typeof bearerHeader !== 'undefined') {
        // Split at the space
        const bearer = bearerHeader.split(' ');
        // Get token from array
        // console.log(bearer)
        const bearerToken = bearer[1];
        // Set the token
        req.token = bearerToken;

        // console.log("fsdf", req.token)

        jwt.verify(req.token, config.secret, function (err, decoded) {
            if (err) {
                return res.json({ success: false, message: 'Failed to authenticate token.' });

            } else {
                // if everything is good, save to request for use in other routes
                // console.log(decoded)
                req.user = decoded;
                return next()




            }
        });

    }
    else {
        res.send("No header")
    }
}


// function verifyToken(req, res, next) {
//     // Get auth header value
//     const bearerHeader = req.headers['authorization'];
//     // Check if bearer is undefined
//     if (typeof bearerHeader !== 'undefined') {
//         // Split at the space
//         const bearer = bearerHeader.split(' ');
//         // Get token from array
//         const bearerToken = bearer[1];
//         // Set the token
//         req.token = bearerToken;
//         // Next middleware
//         next();
//     } else {
//         // Forbidden
//         res.sendStatus(403);
//     }

