package main

import (
	"fmt"
	"log"
	"os"
	"strconv"
)

type Question struct {
	Title    string
	Choices  []string
	Answers  []bool
	Points   int
	Comment  string
	Time     int
	Required bool
}

var DefaultQuestion = Question{
	Time:     -1,
	Required: true,
}

func Parse(raw []byte) ([]Question, error) {
	data := make([]Question, 20)
	q := -1
	a := 0
	t := ""
	flag := ""
	for _, chr := range raw {
		log.Printf("flag = [%s], chr = [%s]\n", flag, string(chr))
		if len(flag) == 0 && chr == ':' {
				data = append(data, DefaultQuestion)
				q += 1
				flag = "T"
				continue
		}
		switch flag[0] {
		case 'T':
			if chr != 0x0A {
				data[q].Title += string(chr)
			} else {
				flag = "QD"
			}
		case 'Q':
			switch flag[1] {
			case 'D':
				switch chr {
				case '=':
					data[q].Choices = append(data[q].Choices, "")
					data[q].Answers = append(data[q].Answers, true)
					flag = "QN"
				case '!':
					data[q].Choices = append(data[q].Choices, "")
					data[q].Answers = append(data[q].Answers, false)
					flag = "QN"
				case '#':
					data[q].Comment = ""
					flag = "QK"
				case ';':
					a = 0
					q += 1
					flag = ""
				case '?':
					data[q].Required = false
				case '"':
					flag = "QT"
				case '/':
					flag = "QP"
				}
			case 'N':
				switch chr {
				case 0x0A:
					a += 1
					flag = "QD"
				case ';':
					a = 0
					flag = ""
				default:
					data[q].Choices[a] += string(chr)
				}
			case 'K':
				if chr == 0x0A {
					flag = "QD"
				} else {
					data[0].Comment += string(chr)
				}
			case 'T':
				if chr == 0x0A {
					time, err := strconv.Atoi(t)
					if err != nil {
						time = -1
					}
					data[q].Time = time
					flag = "QD"
					t = ""
				} else {
					t += string(chr)
				}
			case 'P':
				if chr == 0x0A {
					pts, err := strconv.Atoi(t)
					if err != nil {
						pts = -1
					}
					data[q].Points = pts
					flag = "QD"
					t = ""
				} else {
					t += string(chr)
				}
			}
		}
	}
	return data, nil
}

func main() {
	fmt.Println("File")
	file, err := os.ReadFile(os.Args[1])
	if err != nil {
		panic(err)
	}
	fmt.Println("Parse")
	q, _ := Parse(file)
	fmt.Println(q[0])
}
