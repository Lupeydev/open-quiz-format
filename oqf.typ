#let oqf(file) = {
  let file = read(file)
  if (bytes(file.slice(0,7)) != bytes((0x2A, 0x2A, 0x4F, 0x51, 0x46, 0x2A, 0x0A))) {
    return [Invalid File Header: `#file.slice(0,6)`]
  }
  let raw = bytes(file.slice(7))
  let data = ()
  let q = -1
  let a = 0
  let t = ""
  let flag = ""
  for chr in raw {
    if flag == "" {
      if (chr == bytes(":").at(0)) {
        data.insert(0, 
          (
            title: "",
            choices: (),
            answers: (),
          )
        )
        q+=1
        flag = "T"
      }
    } else if flag == "T" {
      if (chr != 0x0A) {
      data.at(0).title += str.from-unicode(chr)
      } else {
        flag = "QD"
      }
    } else if flag.at(0) == "Q" {
      if flag.at(1) == "D" {
        if chr == bytes("=").at(0) {
          data.at(0).choices.insert(a, "")
          data.at(0).answers.insert(a, true)
          flag = "QN"
        } else if chr == bytes("!").at(0) {
          data.at(0).choices.insert(a, "")
          data.at(0).answers.insert(a, false)
          flag = "QN"
        } else if chr == bytes("#").at(0){

          data.at(0).comment = ""
          flag = "QK"
        } else if chr == bytes(";").at(0) {
          a = 0
          q+= 1
          flag = ""
        } else if chr == bytes("?").at(0) {
          data.at(0).required = false
        } else if chr == bytes("\"").at(0) {
          flag = "QT"
        } else if chr == bytes("/").at(0) {
          flag = "QP"
        } 
      } else if flag.at(1) == "N" {
        if chr == 0x0A {
          a += 1
          flag = "QD"
        } else if chr == bytes(";").at(0) {
          a = 0
          flag = ""
        } else {
          data.at(0).choices.at(a) += str.from-unicode(chr)
        }
      } else if flag.at(1) == "K" {
        if chr == 0x0A {
          flag = "QD"
        } else {
          data.at(0).comment += str.from-unicode(chr)
        }
      } else if flag.at(1) == "T" {
        if chr == 0x0A {
          data.at(0).time = int(t)
          flag = "QD"
          t = ""
        } else {
          t += str.from-unicode(chr)
        }
      } else if flag.at(1) == "P" {
        if chr == 0x0A {
          data.at(0).points = int(t)
          flag = "QD"
          t = ""
        } else {
          t += str.from-unicode(chr)
        }
      }
    } 
  }
  return data.rev()
}
