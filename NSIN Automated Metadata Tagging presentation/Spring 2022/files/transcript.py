import wave, math, contextlib
import speech_recognition as sr
from moviepy.editor import AudioFileClip
from transformers import pipeline
import math
from gensim.summarization import keywords
import sys
import os
import psycopg2
#textrank class to get keywords from transcript
class TextRankImpl:

    def __init__(self, text):
        self.text = text

    def getKeywords(self):
        return (keywords(self.text).split('\n'))

def main(file):
    #connecting to the postgresql database
    connection = psycopg2.connect(user="postgres",
                                  password="password",
                                  host="127.0.0.1",
                                  port="5432",
                                  database="meta")
    cursor = connection.cursor()
    #hard coded files
    #create a temp wav file to be deleted
    print("Opening temp wav file for processing.<br>")
    #open actual
    print("Openeing " + file + " for processing.<br>")
    videoname = file
    print("Completed setting filename = to file to process.<br>")
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
    total_duration = math.ceil(duration / 30)
    r = sr.Recognizer()
    #start and end values used for timestamps
    print("<br>Set start and end variables for proccessing video.<br>")
    print("Total Duration: " + str(total_duration) + "<br>")
    start = 0
    endi = 0
    
    result = []
    #for loop writes the transcription to a text file. Transcription split by 10 seconds
    for i in range(0, total_duration):
        print("<br>")
        #print('Processing page:' + str(i) + '<br>')
        try:
            with sr.AudioFile('/var/www/html/files/' + file) as source:
                audio = r.record(source, offset=i*10, duration=30)
            #add part of transcript to result
            result.append(r.recognize_google(audio))
            print( str(result[i]),end="")
            #print(r.recognize_google(audio),end="")
            print("\n",end="")
            #statement to insert into table
            postgres_insert_query = """ INSERT INTO video_text (video_name, time, metadata, transcript) VALUES (%s,%s,%s,%s)"""
            summaryt = TextRankImpl((result[i]))
            print(summaryt.getKeywords()[:5])
            #record to insert into database table. cursor then puts the data into table
            record_to_insert = (file , endi, summaryt.getKeywords()[:5], result[i])
            print("RECORD TO INSERT: " + record_to_insert[0])
            cursor.execute(postgres_insert_query, record_to_insert)
            connection.commit()
            count = cursor.rowcount
            print(count, "Record inserted successfully into mobile table")
            # closing database connection.
            endi += 30
        except Exception as e:
            print(e)
    summary = TextRankImpl(" ".join(result))
    #prints the textrank keywords and closes postgresql connection
    print("TextRank key words:")
    print(summary.getKeywords()[:5])
    if connection:
        cursor.close()
        connection.close()
        print("PostgreSQL connection is closed")
    
filename = sys.argv[1]
main(filename)
