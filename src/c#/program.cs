using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

class Program
{
    static void Main()
    {
        string[] files = Directory.GetFiles(Directory.GetCurrentDirectory(), "*.oqf");

        foreach (var file in files)
        {
            var questions = QuizCompile.QuizFe(file);
            foreach (var q in questions)
            {
                Console.WriteLine($"Title: {q.Title}");
                Console.WriteLine($"Choices: {string.Join(", ", q.Choices)}");
                Console.WriteLine($"Answers: {string.Join(", ", q.Answers)}");
                Console.WriteLine($"Points: {q.Points} | Time: {q.Time} | Required: {q.Required}");
                Console.WriteLine("---");
            }
        }
    }
}

public class Question
{
    public string Title { get; set; } = "";
    public List<string> Choices { get; set; } = new List<string>();
    public List<bool> Answers { get; set; } = new List<bool>();
    public int Points { get; set; }
    public string Comment { get; set; } = "";
    public int Time { get; set; }
    public bool Required { get; set; } = true;
}

public static class QuizCompile
{
    public static List<Question> Compile(string raw)
    {
        var questions = new List<Question>();
        Question currentQ = null;

        string[] lines = raw.Split(new[] { "\r\n", "\r", "\n" }, StringSplitOptions.None);

        foreach (var rawLine in lines)
        {
            string line = rawLine.Trim();
            if (string.IsNullOrEmpty(line)) continue;

            char identifier = line[0];
            string content = line.Substring(1).Trim();

            switch (identifier)
            {
                case ':':
                    currentQ = new Question { Title = content };
                    questions.Add(currentQ);
                    break;
                case '=':
                    currentQ?.Choices.Add(content);
                    currentQ?.Answers.Add(true);
                    break;
                case '!':
                    currentQ?.Choices.Add(content);
                    currentQ?.Answers.Add(false);
                    break;
                case '"':
                    // Added null check for safety before assignment
                    if (currentQ != null && int.TryParse(content, out int time)) 
                        currentQ.Time = time;
                    break;
                case '/':
                    if (currentQ != null && int.TryParse(content, out int pts)) 
                        currentQ.Points = pts;
                    break;
                case '#':
                    if (currentQ != null) currentQ.Comment = content;
                    break;
                case '?':
                    if (currentQ != null) currentQ.Required = false;
                    break;
                case ';':
                    currentQ = null;
                    break;
            }
        }
        return questions;
    }

    public static List<Question> QuizFe(string filename)
    {
        if (!File.Exists(filename)) return new List<Question>();
        
        string content = File.ReadAllText(filename);
        return Compile(content);
    }
}
