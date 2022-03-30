#!/usr/bin/python3

import requests
import os
from sys import stdin

API_KEY = os.environ['TG_API_KEY']
CHAT_ID = os.environ['TG_CHAT_ID']

text = stdin.read()
#text = "test"

headers = {"Content-Type": "application/json"}
data = {"chat_id": CHAT_ID, "text": text}

url = "https://api.telegram.org/bot%s/sendMessage" % (API_KEY,)
print(url)
resp = requests.post(url, headers=headers, json=data)
print(resp)
