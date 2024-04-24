# VidSnapr-Submission-WWDC24 - Rejected

## App Screenshots

Homepage | Frame selection | Upscaling image
:-: | :-: | :-:
<img src='https://github.com/esikmalazman/VidSnapr-Submission-WWDC24/assets/59039044/c7c68189-41b4-4d78-99dd-8126c9f96a37' width=200/> | <img src='https://github.com/esikmalazman/VidSnapr-Submission-WWDC24/assets/59039044/c1a72048-f308-434b-9868-f720b80d0973' width=200/> | <img src='https://github.com/esikmalazman/VidSnapr-Submission-WWDC24/assets/59039044/992ae590-5ef6-4bb7-bcaf-a3454b515dcf' width=200/>

## Intro & Inspiration

This project inspired following my recent solo travel in Istanbul. Usually when travel by ourselves it is difficult to take moments for memories. Although, we can ask other people to help us take our photos, but it not always easy as it seems due to concerns about safety, anxiety & language barrier. 

Additionally, following this idea I doing a research how solo travellers take their photos. One of the common ways is recording video by themselves and screenshot the video on specific timeline. I found that by using screenshot  will resulting in poor image quality because the screenshot is based on pixel density from the screen and image not originally from video.

Then, since the video actually based on sequence of images, I decided to write application that can get the image from
the video itself which result the image has better image quality compared to screenshots. I also add another capabilities for user to increase their image quality which under the hood using super resolution machine learning model.

 ## How to use the app

1. We can either use existing video from the album or select record button to capture video with the best quality from device.
2. Then, app will redirect to a screen when we can select which image from video we want to have.
3. By selecting continue, user able to preview the image capture and  we can either upscale the image by selecting upscale button or save the image by selecting done button.
4. User also able to remove the image that had been captured by selecting remove button.

   
## Technologies Use

- SwiftUI - To develop screen interface of the app
- AVFoundation - To display video from video album or after record the video and seeking the video on certain time
- Vision - To upscale image captured and load custom Super Resolution CoreML model
- Photos - To allow user to select and save video/images to their album


### References
1. Real ESRGAN Core ML
https://github.com/john-rocky/CoreML-Models?tab=readme-ov-file#real-esrgan

2. Original Real ESRGAN
https://github.com/xinntao/Real-ESRGAN

### Additional Note

- I'm using the Real ESRGAN, which John Rocky converted to a CoreML model. I use open source because I do not have background knowledge in Python and have limited time to develop the project. I used it to show proof of concept using Super Resolution to increase the image quality captured from a video frame. 

- Additionally, I compress the model weights from 65 mb to 16.9 mb to comply with the submission requirements.
