from cv2 import cv2
import numpy as np

# Capturing Video through webcam.
cap = cv2.VideoCapture(0)

while(1):
    _, img = cap.read()

    # converting frame(img) from BGR (Blue-Green-Red) to HSV (hue-saturation-value)
    hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)

    # defining the range of Yellow color
    red_lower = np.array([0, 100, 100], np.uint8)
    red_upper = np.array([2, 255, 255], np.uint8)
    red = cv2.inRange(hsv, red_lower, red_upper)

    # Morphological transformation, Dilation
    kernal = np.ones((5, 5), "uint8")
    res = cv2.bitwise_and(img, img, mask=red)

    # Tracking Colour (Yellow)
    (contours, hierarchy) = cv2.findContours(
        red, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

    for pic, contour in enumerate(contours):
        area = cv2.contourArea(contour)
        if(area > 900):

            x, y, w, h = cv2.boundingRect(contour)
            img = cv2.rectangle(img, (x, y), (x+w, y+h), (255, 0, 0), 3)

    # show color detection result
    cv2.imshow("Color Tracking", img)
    cv2.imshow("Red", res)

    if cv2.waitKey(10) & 0xFF == 27:
        cap.release()
        cv2.destroyAllWindows()
        break
