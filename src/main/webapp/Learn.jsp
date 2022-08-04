<%--
  Created by IntelliJ IDEA.
  User: Вероника
  Date: 07.06.2022
  Time: 2:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Real-Time Facial Emotion Detection</title>
    <link rel="stylesheet" href="css/normalize.css"/>
    <link rel="stylesheet" href="css/detection.css"/>
    <link rel="stylesheet" href="css/learn.css"/>
    <!--<link href="css/toast.css" rel="stylesheet">-->
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
<p class="description">На этой странице ты сможешь научится навыкам выражения эмоций в форме игры.<br>Для этого попробуй
    изобразить 7 эмоций по очереди.
</p>
<h2 class="emotion" id="emotionNow"></h2>

<div class="video-container">
    <canvas id="output" class="canvas"></canvas>

    <div class="inputs">
        <input type="checkbox" disabled id="c1" value="angry">
        <label for="c1">злость</label>

        <input type="checkbox" disabled id="c2" value="disgust">
        <label for="c2">отвращение</label>

        <input type="checkbox" disabled id="c3" value="fear">
        <label for="c3">страх</label>

        <input type="checkbox" disabled id="c4" value="happy">
        <label for="c4">счастье</label>

        <input type="checkbox" disabled id="c5" value="neutral">
        <label for="c5">нейтральное&nbsp;выражение</label>

        <input type="checkbox" disabled id="c6" value="sad">
        <label for="c6">грусть</label>

        <input type="checkbox" disabled id="c7" value="surprise">
        <label for="c7">удивление</label>

        <button class="reset-button" id="reset-button" onClick='reset();'>Еще раз</button>

    </div>
</div>

<h1 class="emotion" id="status">Загрузка...</h1>


<video class="webcam" id="webcam" playsinline style="
            visibility: hidden;
            width: 10px;
            height: 10px;
            ">
</video>

<script>

    //require('./render.js');

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
    let emotion = null;
    let index = 0;
    let mayreset = false;

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

    function reset() {

        mayreset = false;
        index = 0;
        for (var i = 1; i < 8; i++) {
            document.getElementById("c" + i).checked = false;
        }
        document.getElementById("reset-button").style.visibility = 'hidden';
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
            emotion = await predictEmotion(points);
            //setText(`Распознана эмоция: ${emotion}`);
            setText(``);
            if (!mayreset) {
                //document.getElementById("emotionNow").innerText = `Попробуй изобразить ${emotions[index]}`;}
                document.getElementById("emotionNow").innerText = "Попробуйте изобразить " + emotions[index];
            }
            if (emotion === emotions[index]) {
                /*
  title - название заголовка
  text - текст сообщения
  theme - тема
  autohide - нужно ли автоматически скрыть всплывающее сообщение через interval миллисекунд
  interval - количество миллисекунд через которые необходимо скрыть сообщение
*/
                /*  new Toast({
                      title: false,
                      text: `Вы смогли изобразить

                ${emotions[index]}`,
                    theme: 'danger',
                    autohide: true,
                    interval: 10000
                });

               */

                var ind = index + 1;
                document.getElementById(`c` + ind).checked = true;
                if (index < 6) {
                    index++;
                } else {
                    document.getElementById("emotionNow").innerText = 'Вы смогли изобразить все эмоции!  ' + '\r\n' + '  Для того чтобы попробовать еще раз нажмите на кнопку еще раз.';
                    document.getElementById("reset-button").style.visibility = 'visible';
                    mayreset = true;

                }
            }
        } else {
            setText("Лицо не обнаруженно");
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

        //setText("Loaded!");

        trackFace();
    })();
    //require('./render.js');
</script>
<!--<script src="toast.js"></script>-->
</body>
</html>
