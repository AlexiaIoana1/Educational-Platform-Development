from flask import Flask, render_template, request, session, redirect, url_for
import mysql.connector

app = Flask(__name__)
app.secret_key = 'secret-key'

@app.route("/")
def index():
    return render_template("homepage.html")

@app.route("/homepage")
def home():
    return render_template("homepage.html")

@app.route("/student_list")
def student_list():
    student = []
    conn = connection()
    cursor = conn.cursor()
    cursor.execute(
        "SELECT ID_Student, Nume, Adresa, Sex, Data_Nastere, Date_Contact FROM STUDENTI ")
    for row in cursor.fetchall():
        student.append({"ID_Student": row[0], "Nume": row[1], "Adresa": row[2], "Sex": row[3], "Data_Nastere": row[4],
                        "Date_Contact": row[5]})
    cursor.close()
    conn.close()
    return render_template("student_list.html", student=student)

@app.route("/course_list")
def course_list():
    course = []
    conn = connection()
    cursor = conn.cursor()
    cursor.execute('''SELECT I.Nume , C.Denumire, C.Descriere, C.Data_Incepere, C.Data_Incheiere
                       FROM INSTRUCTORI AS I INNER JOIN CURSURI AS C ON C.ID_Instructor = I.ID_Instructor''')
    for row in cursor.fetchall():
        course.append({"Nume": row[0], "Denumire": row[1], "Descriere": row[2], "Data_Incepere": row[3], "Data_Incheiere": row[4]})
    conn.commit()
    conn.close()
    return render_template("courses_list.html", course=course)

@app.route("/attendance")
def attendance():
    attendance = []
    conn = connection()
    cursor = conn.cursor()
    cursor.execute('''SELECT S.Nume , C.Denumire, PC.Stare_Prezenta, PC.Data_Prezenta, PC.Motiv_Absenta
                       FROM PARTICIPARE_CURSURI AS PC INNER JOIN CURSURI AS C ON C.ID_Curs = PC.ID_Curs
                                                          INNER JOIN STUDENTI AS S ON S.ID_Student= PC.ID_Student''')
    for row in cursor.fetchall():
        attendance.append({"Nume": row[0], "Denumire": row[1], "Stare_Prezenta": row[2], "Data_Prezenta": row[3], "Motiv_Absenta": row[4]})
    conn.commit()
    conn.close()
    return render_template("attendance.html", attendance=attendance)

@app.route("/lessons_list", methods = ['GET','POST'])
def lessons_list():

    if request.method == 'GET':
        return render_template('lessons_list.html')

    if request.method == 'POST':
        ncurs = request.form['ncurs']

        lesson = []

        if request.form['ncurs'] != '':

            conn = connection()
            cursor = conn.cursor()

            cursor.execute('''SELECT C.Denumire , L.Titlu_Lectie, L.Descriere, L.Durata
                               FROM CURSURI AS C JOIN LECTII AS L ON C.ID_Curs = L.ID_Curs
                               WHERE C.Denumire = %s ''', (ncurs,))

            curs_aux = cursor.fetchall()

            conn.commit()
            conn.close()

            for row in curs_aux:
                lesson.append({"Denumire": row[0], "Titlu_Lectie": row[1], "Descriere": row[2], "Durata": row[3]})


        return render_template("lessons_list.html", lesson = lesson)

@app.route("/find_exam", methods=['GET', 'POST'])
def find_exam():

    if request.method == 'GET':
        return render_template('find_exam.html')

    if request.method == 'POST':

        numeprof = request.form['numeprof']
        numecurs = request.form['numecurs']
        tipexam = request.form['tipexam']

        exam = []

        if request.form['numeprof'] != '' and request.form['numecurs'] == '' and request.form['tipexam'] == '':

            conn = connection()
            cursor = conn.cursor()

            cursor.execute('''   SELECT I.Nume, C.Denumire, EM.Tip_Examen, EM.Data_Sustinerii, EM.Durata, EM.Punctaj_Minim, 
                                            (SELECT COUNT(*)
                                             FROM PARTICIPARE_CURSURI AS PC
                                             WHERE PC.ID_Curs = C.ID_Curs) AS Total_Studenti
                                             FROM CURSURI AS C
                                             JOIN INSTRUCTORI AS I ON C.ID_Instructor = I.ID_Instructor
                                             JOIN EXAMEN_FINAL AS EM ON EM.ID_Curs = C.ID_Curs
                                             WHERE I.Nume = %s
                                             ORDER BY EM.Punctaj_Minim DESC ''', (numeprof,))
            exam_aux = cursor.fetchall()
            conn.commit()

            for row in exam_aux:
                exam.append({"Nume": row[0], "Denumire": row[1], "Tip_Examen": row[2],
                             "Data_Sustinerii": row[3],"Durata": row[4], "Punctaj_Minim": row[5],
                             "Total_Studenti": row[6]})
            conn.close()

        if request.form['numeprof'] == '' and request.form['numecurs'] != '' and request.form['tipexam'] == '':

            conn = connection()
            cursor = conn.cursor()

            cursor.execute('''   SELECT I.Nume, C.Denumire, EM.Tip_Examen, EM.Data_Sustinerii, EM.Durata, EM.Punctaj_Minim, 
                                                (SELECT COUNT(*)
                                                 FROM PARTICIPARE_CURSURI AS PC
                                                 WHERE PC.ID_Curs = C.ID_Curs) AS Total_Studenti
                                                 FROM CURSURI AS C
                                                 JOIN INSTRUCTORI AS I ON C.ID_Instructor = I.ID_Instructor
                                                 JOIN EXAMEN_FINAL AS EM ON EM.ID_Curs = C.ID_Curs
                                                 WHERE C.Denumire = %s ''', (numecurs, ))
            exam_aux = cursor.fetchall()
            conn.commit()

            for row in exam_aux:
                exam.append({"Nume": row[0], "Denumire": row[1], "Tip_Examen": row[2],
                             "Data_Sustinerii": row[3], "Durata": row[4], "Punctaj_Minim": row[5],
                             "Total_Studenti": row[6]})
            conn.close()

        if request.form['numeprof'] == '' and request.form['numecurs'] == '' and request.form['tipexam'] != '':

                conn = connection()
                cursor = conn.cursor()

                cursor.execute('''   SELECT I.Nume, C.Denumire, EM.Tip_Examen, EM.Data_Sustinerii, EM.Durata, EM.Punctaj_Minim, 
                                                    (SELECT COUNT(*)
                                                     FROM PARTICIPARE_CURSURI AS PC
                                                     WHERE PC.ID_Curs = C.ID_Curs) AS Total_Studenti
                                                     FROM CURSURI AS C
                                                     JOIN INSTRUCTORI AS I ON C.ID_Instructor = I.ID_Instructor
                                                     JOIN EXAMEN_FINAL AS EM ON EM.ID_Curs = C.ID_Curs
                                                     WHERE EM.Tip_Examen = %s ''',(tipexam, ))
                exam_aux = cursor.fetchall()
                print("Rezultat query:", exam_aux)
                conn.commit()

                for row in exam_aux:
                    exam.append({"Nume": row[0], "Denumire": row[1], "Tip_Examen": row[2],
                                 "Data_Sustinerii": row[3], "Durata": row[4], "Punctaj_Minim": row[5],
                                 "Total_Studenti": row[6]})
                conn.close()

        return render_template('find_exam.html', exam=exam)

@app.route("/student_add", methods=['GET', 'POST'])
def student_add():
    if request.method == 'GET':
        return render_template("student_add.html")

    elif request.method == 'POST':
        numestud = request.form['numestud']
        adresa = request.form['adresa']
        sex = request.form['sex']
        datanastere = request.form['datanastere']
        datecontact = request.form['datecontact']
        numecurs = request.form['numecurs']
        stareprezenta = request.form['stareprezenta']
        dataprezenta = request.form['dataprezenta']
        motivare = request.form['motivare']

        conn = connection()
        cursor = conn.cursor()

        cursor.execute('''
            INSERT INTO STUDENTI (Nume, Adresa, Sex, Data_Nastere, Date_Contact)
            VALUES (%s, %s, %s, %s, %s)
        ''', (numestud, adresa, sex, datanastere, datecontact))

        cursor.execute("SELECT ID_Student FROM STUDENTI WHERE Nume = %s", (numestud,))
        id_student_row = cursor.fetchone()

        cursor.execute("SELECT ID_Curs FROM CURSURI WHERE Denumire = %s", (numecurs,))
        id_curs_row = cursor.fetchone()

        if not id_student_row or not id_curs_row:
            conn.rollback()
            conn.close()
            return "Eroare: studentul sau cursul nu există în baza de date."

        id_student = id_student_row[0]
        id_curs = id_curs_row[0]

        cursor.execute('''
            INSERT INTO PARTICIPARE_CURSURI (ID_Curs, ID_Student, Stare_Prezenta, Data_Prezenta, Motiv_Absenta)
            VALUES (%s, %s, %s, %s, %s)
        ''', (id_curs, id_student, stareprezenta, dataprezenta, motivare))

        conn.commit()
        conn.close()

        return redirect('/')


@app.route("/update_student", methods=['GET', 'POST'])
def update_student():
    if request.method == 'GET':
        return render_template("update_student.html")

    elif request.method == 'POST':
        numestud = request.form['numestud']
        adresa = request.form['adresa']
        datanastere = request.form['datanastere']
        datecontact = request.form['datecontact']
        numecurs = request.form['numecurs']
        stareprezenta = request.form['stareprezenta']
        dataprezenta = request.form['dataprezenta']
        motivare = request.form['motivare']

        conn = connection()
        cursor = conn.cursor()

        cursor.execute("SELECT ID_Student FROM STUDENTI WHERE Nume = %s", (numestud,))
        id_student_row = cursor.fetchone()
        cursor.execute("SELECT ID_Curs FROM CURSURI WHERE Denumire = %s", (numecurs,))
        id_curs_row = cursor.fetchone()

        if not id_student_row or not id_curs_row:
            conn.close()
            return "Eroare: Studentul sau cursul nu există."

        id_student = id_student_row[0]
        id_curs = id_curs_row[0]

        cursor.execute('''
            UPDATE STUDENTI 
            SET Adresa = %s, Data_Nastere = %s, Date_Contact = %s
            WHERE ID_Student = %s
        ''', (adresa, datanastere, datecontact, id_student))

        cursor.execute('''
            UPDATE PARTICIPARE_CURSURI 
            SET Stare_Prezenta = %s, Data_Prezenta = %s, Motiv_Absenta = %s
            WHERE ID_Student = %s AND ID_Curs = %s
        ''', (stareprezenta, dataprezenta, motivare, id_student, id_curs))

        conn.commit()
        conn.close()

        return redirect('/')

@app.route('/delete/<int:id_student>', methods=['GET','POST'])
def delete(id_student):
    conn = connection()
    cursor = conn.cursor()

    # Nu mai e nevoie să cauți ID-ul, îl ai deja
    cursor.execute('DELETE FROM PARTICIPARE_CURSURI WHERE ID_Student = %s', (id_student,))
    cursor.execute('DELETE FROM STUDENTI WHERE ID_Student = %s', (id_student,))
    conn.commit()

    cursor.close()
    conn.close()
    return redirect(url_for('student_list'))

def connection():

    conn = mysql.connector.connect(
        host="localhost",
        user="root",
        password="alexia",
        database="evidenta_participare_cursuri_online",
        autocommit = True
    )
    return conn

if __name__ == "__main__":
    app.run(debug=True)
