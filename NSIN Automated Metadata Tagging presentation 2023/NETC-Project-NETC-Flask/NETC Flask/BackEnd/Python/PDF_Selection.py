import spacy
import pdfplumber
from spacy.lang.en.stop_words import STOP_WORDS
from string import punctuation
from heapq import nlargest
import os
from BackEnd.Python.s3upload import upload_to_aws


#fileTest = "/Users/jose.silverio/Downloads/NETC-Project-NETC-Flask/NETC Flask/BackEnd/Python/Project_4.pdf"
FilePath = os.path.dirname(__file__)
#Bucket name for AWS
BUCKET_NAME = 'netc-filestorage'

def openFile(the_file,filename):

    #Pass file to Meta and Convert file to Text
    Meta(the_file,filename)
    ConvertFile_txt(the_file,filename)


def Meta(the_file,filename):
    with pdfplumber.open(the_file) as pdf:
        print(pdf.metadata, file=open(FilePath + "/" + 'Meta.txt', 'a'))
        print(pdf.pages, file=open(FilePath + "/" + 'Meta.txt', 'a'))

    uploaded = upload_to_aws(FilePath + "/" + 'Meta.txt',BUCKET_NAME,'Meta-Data-Storage/' + filename + '/Meta.txt')
    os.remove(os.path.dirname(__file__) + "/Meta.txt")
    pass


def ConvertFile_txt(the_file,filename):
    with pdfplumber.open(the_file) as pdf:
        for page in pdf.pages:
            text_pdf = page.extract_text()
            # print(text_pdf)
    Text_Summerizer(text_pdf,filename)
    KeyWord(text_pdf,filename)
    pass


def Text_Summerizer(text_pdf,filename):
    nlp = spacy.load('en_core_web_sm')
    doc = nlp(text_pdf)
    tokens = [token.text for token in doc]
    word_frequencies = {}
    for word in doc:
        if word.text.lower() not in list(STOP_WORDS):
            if word.text.lower() not in punctuation:
                if word.text not in word_frequencies.keys():
                    word_frequencies[word.text] = 1
                else:
                    word_frequencies[word.text] += 1
    max_frequency = max(word_frequencies.values())
    for word in word_frequencies.keys():
        word_frequencies[word] = word_frequencies[word]/max_frequency
    sentence_tokens = [sent for sent in doc.sents]
    sentence_scores = {}
    for sent in sentence_tokens:
        for word in sent:
            if word.text.lower() in word_frequencies.keys():
                if sent not in sentence_scores.keys():
                    sentence_scores[sent] = word_frequencies[word.text.lower()]
                else:
                    sentence_scores[sent] += word_frequencies[word.text.lower()]
    select_length = int(len(sentence_tokens)*1)
    summary = nlargest(select_length, sentence_scores, key=sentence_scores.get)
    final_summary = [word.text for word in summary]
    summary = ''.join(final_summary)
    print(summary, file=open(FilePath + "/" + "summary.txt", 'w'))
    uploaded = upload_to_aws(FilePath + "/" + 'summary.txt',BUCKET_NAME,'Meta-Data-Storage/' + filename + '/summary.txt')
    os.remove(os.path.dirname(__file__) + "/summary.txt")
    pass


def KeyWord(text_pdf,filename):
    nlp = spacy.load('en_core_web_sm')
    pos_tag = ['PROPN', 'ADJ', 'NOUN']  # 1
    doc = nlp(text_pdf.lower())  # 2
    result = []
    for token in doc:
       # 3
        if (token.text in nlp.Defaults.stop_words or token.text in punctuation):
            continue
    # 4
        if (token.pos_ in pos_tag):
            result.append(token.text)
    print(result, file=open(FilePath + "/" + "keywords_from_document.txt", 'w'))
    uploaded = upload_to_aws(FilePath + "/" + 'keywords_from_document.txt',BUCKET_NAME,'Meta-Data-Storage/' + filename + '/keywords_from_document.txt')
    os.remove(os.path.dirname(__file__) + "/keywords_from_document.txt")
    pass


#openFile(fileTest)
