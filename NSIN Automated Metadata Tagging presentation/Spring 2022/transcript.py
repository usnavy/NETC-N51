#this code will generate a complete transcript with timestamps of 10 second intervals
import wave, math, contextlib
import speech_recognition as sr
from moviepy.editor import AudioFileClip
from transformers import pipeline
import math
from gensim.summarization import keywords
import tkinter as tk     # from tkinter import Tk for Python 3.x
from tkinter.filedialog import askopenfilename

class TextRankImpl:

    def __init__(self, text):
        self.text = text

    def getKeywords(self):
        return (keywords(self.text).split('\n'))

def main(file):

    #hard coded files
    transcribed_audio_file_name = "test1.wav"
    videoname = file
    #AudioFileClip class from the moviepy.editor to convert the video to audio.
    audioclip = AudioFileClip(videoname)
    audioclip.write_audiofile(transcribed_audio_file_name)
    #s10MB per call, therefore must split audio. This gets number of frames and framerate to get duration value
    with contextlib.closing(wave.open(transcribed_audio_file_name,'r')) as f:
        frames = f.getnframes()
        rate = f.getframerate()
        duration = frames / float(rate)
    #total duration
    total_duration = math.ceil(duration / 10)
    r = sr.Recognizer()
    #start and end values used for timestamps
    start = 0
    end = 10
    result = []
    #for loop writes the transcription to a text file. Transcription split by 10 seconds
    for i in range(0, total_duration):
        with sr.AudioFile(transcribed_audio_file_name) as source:
            audio = r.record(source, offset=i*10, duration=10)
        if end == 60:
            start +=1
            end = 0
        result.append(r.recognize_google(audio))
        f = open("transcription2.txt", "a")
        f.write(str(start))
        f.write(":")
        f.write(str(end))
        f.write(": ")
        f.write(r.recognize_google(audio))
        f.write("\n")
        end += 10
    
    f.close()

    summary = TextRankImpl(" ".join(result))
    print("TextRank key words:")
    print(summary.getKeywords()[:5])

    #T5 summarizer
    summarizer = pipeline("summarization", model="t5-base", tokenizer="t5-base", framework="tf")
    print(summarizer(" ".join(result), min_length=1, max_length=50))

filename = askopenfilename() 
main(filename)
