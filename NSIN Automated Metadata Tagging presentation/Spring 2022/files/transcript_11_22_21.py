import wave, math, contextlib
import speech_recognition as sr
from moviepy.editor import AudioFileClip
from transformers import pipeline
import math
from gensim.summarization import keywords
import sys
import os

class TextRankImpl:

    def __init__(self, text):
        self.text = text

    def getKeywords(self):
        return (keywords(self.text).split('\n'))

def main(file):
    try:
        connection = psycopg2.connect(user="postgres",
                                  password="password",
                                  host="127.0.0.1",
                                  port="5432",
                                  database="meta")
    cursor = connection.cursor()
    #hard coded files
    #create a temp wav file to be deleted
    print("Opening temp wav file for processing.<br>")
    #transcribed_audio_file_name = "test_mp4_file.wav" 
    #open actual video file
    print("Openeing " + file + " for processing.<br>")
    #videoname = "../files/" + file
    videoname = file
    print("Completed setting filename = to file to process.<br>")
    #AudioFileClip class from the moviepy.editor to convert the video to audio.
    #audioclip = AudioFileClip(videoname)
    print("Completed setting audioclip to video name<br>")
    #audioclip.write_audiofile(transcribed_audio_file_name)
    print("Creating audio clip and audioclip write object.<br>")
    #s10MB per call, therefore must split audio. This gets number of frames and framerate to get duration value
    ##########Not working past here, not opening the file to read############
    try:
        with contextlib.closing(wave.open('/var/www/html/files/' + file,'rb')) as f:
            frames = f.getnframes()
            rate = f.getframerate()
            duration = frames / float(rate)
    except Exception as e:
        print(e)
    #####################testing try except#################
    #total duration
    print("<br>Setting the recognizer function")
    total_duration = math.ceil(duration / 10)
    r = sr.Recognizer()
    #start and end values used for timestamps
    print("<br>Set start and end variables for proccessing video.<br>")
    print("Total Duration: " + str(total_duration) + "<br>")
    start = 0
    endi = 10
    result = []
    #for loop writes the transcription to a text file. Transcription split by 10 seconds
    for i in range(0, total_duration):
        print("<br>")
        #print('Processing page:' + str(i) + '<br>')
        try:
            with sr.AudioFile('/var/www/html/files/' + file) as source:
                audio = r.record(source, offset=i*10, duration=10)
            if endi == 60:
                start +=1
                endi = 0
                
            result.append(r.recognize_google(audio))
            #f = open("transcription.txt", "a")
            print(str(start),end="")
            print(":",end="")
            print(str(endi),end="")
            print(": " + str(result[i]),end="")
            
            #print(r.recognize_google(audio),end="")
            print("\n",end="")
            endi += 10
        except Exception as e:
            print(e)
    summary = TextRankImpl(" ".join(result))
    #print(" ".join(result))
    print("TextRank key words:")
    print(summary.getKeywords()[:5])
    os.remove("../tmp/test_mp4_file.wav")

    #T5 summarizer
    #summarizer = pipeline("summarization", model="t5-base", tokenizer="t5-base", framework="tf")
    #print(summarizer(" ".join(result), min_length=1, max_length=50))

filename = sys.argv[1]
main(filename)
