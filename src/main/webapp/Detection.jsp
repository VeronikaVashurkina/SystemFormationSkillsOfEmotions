<%@ page import="database.entitys.User" %>
<%--
  Created by IntelliJ IDEA.
  User: Вероника
  Date: 19.05.2022
  Time: 17:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%User usr = (User) session.getAttribute("usr");%>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Real-Time Facial Emotion Detection</title>
    <link rel="shortcut icon" href="img/heart_kill_icon.png">
    <link rel="stylesheet" href="css/normalize.css"/>
    <link rel="stylesheet" href="css/detection.css"/>
    <link rel="stylesheet" href="css/login.css"/>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/@tensorflow/tfjs@2.4.0/dist/tf.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@tensorflow-models/face-landmarks-detection@0.0.1/dist/face-landmarks-detection.js"></script>
</head>
<body>
<div class="menu-buttons">

    <button class="menu-button" onClick='location.href="http://localhost:8090/Emotion_war_exploded/UserServlet" '>
        Профиль
    </button>
    <button class="menu-button" onClick='location.href="http://localhost:8090/Emotion_war_exploded/LearnServlet"'>
        Обучение
    </button>
    <button class="menu-button" onClick='location.href="http://localhost:8090/Emotion_war_exploded/DetectionServlet"'>
        Распознавание
    </button>
    <button class="menu-button" onClick='location.href="http://localhost:8090/Emotion_war_exploded/HistoryServlet"'>
        История
    </button>

</div>
<form action="/Emotion_war_exploded/DetectionServlet?id=<%out.println(usr.getUserId());%>" method="post">
    <canvas id="output" class="canvas"></canvas>
    <h1 class="emotion" id="status" name="emotion">Загрузка...</h1>
    <input id="em" type="text" name="emotion" value="">
    <input class="danger-button" type="submit" value="Добавить в историю">
</form>

<video class="webcam" id="webcam" playsinline style="
            visibility: hidden;
            width: 10px;
            height: 10px;
            ">
</video>

<script>


    function setText(text) {
        document.getElementById("status").innerText = text;
    }

    function drawLine(ctx, x1, y1, x2, y2) {
        ctx.beginPath();
        ctx.moveTo(x1, y1);
        ctx.lineTo(x2, y2);
        ctx.stroke();
    }

    async function setupWebcam() {
        return new Promise((resolve, reject) => {
            const webcamElement = document.getElementById("webcam");
            const navigatorAny = navigator;
            navigator.getUserMedia = navigator.getUserMedia ||
                navigatorAny.webkitGetUserMedia || navigatorAny.mozGetUserMedia ||
                navigatorAny.msGetUserMedia;
            if (navigator.getUserMedia) {
                navigator.getUserMedia({video: true},
                    stream => {
                        webcamElement.srcObject = stream;
                        webcamElement.addEventListener("loadeddata", resolve, false);
                    },
                    error => reject());
            } else {
                reject();
            }
        });
    }

    const emotions = ["злость", "отвращение", "страх", "счастье", "нейтральное выражение", "грусть", "удивление"];
    let emotionModel = null;

    let output = null;
    let model = null;

    async function predictEmotion(points) {
        let result = tf.tidy(() => {
            const xs = tf.stack([tf.tensor1d(points)]);
            return emotionModel.predict(xs);
        });
        let prediction = await result.data();
        result.dispose();
        // Get the index of the maximum value
        let id = prediction.indexOf(Math.max(...prediction));
        return emotions[id];
    }

    async function trackFace() {
        const video = document.querySelector("video");
        const faces = await model.estimateFaces({
            input: video,
            returnTensors: false,
            flipHorizontal: false,
        });
        output.drawImage(
            video,
            0, 0, video.width, video.height,
            0, 0, video.width, video.height
        );

        let points = null;
        faces.forEach(face => {
            // Draw the bounding box
            const x1 = face.boundingBox.topLeft[0];
            const y1 = face.boundingBox.topLeft[1];
            const x2 = face.boundingBox.bottomRight[0];
            const y2 = face.boundingBox.bottomRight[1];
            const bWidth = x2 - x1;
            const bHeight = y2 - y1;
            drawLine(output, x1, y1, x2, y1);
            drawLine(output, x2, y1, x2, y2);
            drawLine(output, x1, y2, x2, y2);
            drawLine(output, x1, y1, x1, y2);

            // Add just the nose, cheeks, eyes, eyebrows & mouth
            const features = [
                "noseTip",
                "leftCheek",
                "rightCheek",
                "leftEyeLower1", "leftEyeUpper1",
                "rightEyeLower1", "rightEyeUpper1",
                "leftEyebrowLower", //"leftEyebrowUpper",
                "rightEyebrowLower", //"rightEyebrowUpper",
                "lipsLowerInner", //"lipsLowerOuter",
                "lipsUpperInner", //"lipsUpperOuter",
            ];
            points = [];
            features.forEach(feature => {
                face.annotations[feature].forEach(x => {
                    points.push((x[0] - x1) / bWidth);
                    points.push((x[1] - y1) / bHeight);
                });
            });
        });

        if (points) {
            let emotion = await predictEmotion(points);
            //setText(`Detected: ${emotion}`);
            setText("Распознана эмоция: ");
            document.getElementById('em').value = emotion;
            //setText(emotion);
        } else {
            setText("Лицо не обнаружено");
            document.getElementById('em').value = "";
        }

        requestAnimationFrame(trackFace);
    }

    (async () => {
        await setupWebcam();
        const video = document.getElementById("webcam");
        video.play();
        let videoWidth = video.videoWidth;
        let videoHeight = video.videoHeight;
        video.width = videoWidth;
        video.height = videoHeight;

        let canvas = document.getElementById("output");
        canvas.width = video.width;
        canvas.height = video.height;

        output = canvas.getContext("2d");
        output.translate(canvas.width, 0);
        output.scale(-1, 1); // Mirror cam
        output.fillStyle = "#cc0000";
        output.strokeStyle = "#cc0000";
        output.lineWidth = 2;

        // Load Face Landmarks Detection
        model = await faceLandmarksDetection.load(
            faceLandmarksDetection.SupportedPackages.mediapipeFacemesh
        );
        // Load Emotion Detection
        emotionModel = await tf.loadLayersModel('web/model/facemo.json');

        setText("Загружено!");

        trackFace();
    })();

</script>
</body>
</html>
