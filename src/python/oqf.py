import os
from unittest import case

class Question:
    def __init__(self, title="", choices=None, answers=None, points=0, comment="", time=0):
        self.Title = title
        self.Choices = choices or []
        self.Answers = answers or []
        self.Points = points
        self.Comment = comment
        self.Time = time
        self.Required = True

def parse(raw):
    questions = []
    q = None

    for line in map(str.strip, raw.splitlines()):
        if not line:
            continue
        match line[0]:
            case ":":
                q = Question(title=line[1:].strip())
                questions.append(q)
            case "=":
                q.Choices.append(line[1:].strip())
                q.Answers.append(True)
            case "!":
                q.Choices.append(line[1:].strip())
                q.Answers.append(False)
            case '"':
                try:
                    q.Time = int(line[1:])
                except ValueError:
                    q.Time = 0
            case '/':
                try:
                    q.Points = int(line[1:])
                except ValueError:
                    q.Points = 0
            case "#":
                q.Comment = line[1:].strip()
            case "?":
                q.Required = False
            case ";":
                q = None
    return questions

def quiz_fe(filename):
    with open(filename, encoding="utf-8") as f:
        return parse(f.read())

for q in os.listdir("."):
    if q.endswith(".oqf"):
        questions = quiz_fe(q)
        for q in questions:
            print("Title:", q.Title)
            print("Choices:", q.Choices)
            print("Answers:", q.Answers)
            print("---")