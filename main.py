from flask import Flask, render_template, request, session, redirect, url_for
import pyodbc

app = Flask(__name__)
app.secret_key = 'secret-key'

@app.route("/")
def index():
    return render_template("index.html")

@app.route('/login', methods=['GET', 'POST'])
def login():
    msg = ''
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        if username in users and users[username] == password:
            session['username'] = username
            return render_template('homepage.html')
        else:
            return render_template('index.html', error='Invalid username or password')
    else:
            return render_template('index.html')

@app.route("/homepage")
def home():
    return render_template("homepage.html")

@app.route("/student_list")
def student_list():
    student = []
    conn = connection()
    cursor = conn.cursor()
    cursor.execute(
        "SELECT S.ID_Student, S.Nume, S.Adresa, S.Sex, S.Data_Nastere, S.Date_Contact FROM dbo.STUDENTI AS S")
    for row in cursor.fetchall():
        student.append({"ID_Student": row[0], "Nume": row[1], "Adresa": row[2], "Sex": row[3], "Data_Nastere": row[4],
                        "Date_Contact": row[5]})
    conn.commit()
    conn.close()
    return render_template("student_list.html", student=student)

@app.route("/course_list")
def course_list():
    course = []
    conn = connection()
    cursor = conn.cursor()
    cursor.execute('''SELECT I.Nume , C.Denumire, C.Descriere, C.Data_Incepere, C.Data_Incheiere
                       FROM dbo.INSTRUCTORI AS I INNER JOIN CURSURI AS C ON C.ID_Instructor = I.ID_Instructor''')
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
                       FROM dbo.PARTICIPARE_CURSURI AS PC INNER JOIN CURSURI AS C ON C.ID_Curs = PC.ID_Curs
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

            curs_aux = cursor.execute('''SELECT C.Denumire , L.Titlu_Lectie, L.Descriere, L.Durata
                               FROM dbo.CURSURI AS C JOIN LECTII AS L ON C.ID_Curs = L.ID_Curs
                               WHERE C.Denumire = ? ''' , ncurs).fetchall()
            conn.commit()

            for row in curs_aux:
                lesson.append({"Denumire": row[0], "Titlu_Lectie": row[1], "Descriere": row[2], "Durata": row[3]})

            conn.close()
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

            exam_aux = cursor.execute('''   SELECT I.Nume, C.Denumire, EM.Tip_Examen, EM.Data_Sustinerii, EM.Durata, EM.Punctaj_Minim, 
                                            (SELECT COUNT(*)
                                             FROM PARTICIPARE_CURSURI AS PC
                                             WHERE PC.ID_Curs = C.ID_Curs) AS Total_Studenti
                                             FROM CURSURI AS C
                                             JOIN INSTRUCTORI AS I ON C.ID_Instructor = I.ID_Instructor
                                             JOIN EXAMEN_FINAL AS EM ON EM.ID_Curs = C.ID_Curs
                                             WHERE I.Nume = ?
                                             ORDER BY EM.Punctaj_Minim DESC ''', numeprof).fetchall()

            conn.commit()

            for row in exam_aux:
                exam.append({"Nume": row[0], "Denumire": row[1], "Tip_Examen": row[2],
                             "Data_Sustinerii": row[3],"Durata": row[4], "Punctaj_Minim": row[5],
                             "Total_Studenti": row[6]})
            conn.close()

        if request.form['numeprof'] != '' and request.form['numecurs'] == '' and request.form['tipexam'] == '':

            conn = connection()
            cursor = conn.cursor()

            exam_aux = cursor.execute('''   SELECT I.Nume, C.Denumire, EM.Tip_Examen, EM.Data_Sustinerii, EM.Durata, EM.Punctaj_Minim, 
                                                (SELECT COUNT(*)
                                                 FROM PARTICIPARE_CURSURI AS PC
                                                 WHERE PC.ID_Curs = C.ID_Curs) AS Total_Studenti
                                                 FROM CURSURI AS C
                                                 JOIN INSTRUCTORI AS I ON C.ID_Instructor = I.ID_Instructor
                                                 JOIN EXAMEN_FINAL AS EM ON EM.ID_Curs = C.ID_Curs
                                                 WHERE C.Denumire = ? AND EM.Tip_Examen = ? ''', numecurs, tipexam).fetchall()

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
        cursor.execute(
            "INSERT INTO dbo.STUDENTI ( Nume, Adresa, Sex, Data_Nastere , Date_Contact) "
            "VALUES ( ?, ?, ?, ? , ?)", numestud, adresa, sex, datanastere, datecontact)
        conn.commit()
        conn.close()

        conn = connection()
        cursor = conn.cursor()
        cursor.execute (''' INSERT INTO dbo.PARTICIPARE_CURSURI (ID_Curs, ID_Student, Stare_Prezenta, Data_Prezenta, Motiv_Absenta)
                            SELECT C.ID_Curs, S.ID_Student, ?, ?, ?
                            FROM CURSURI C, STUDENTI S
                            WHERE C.Denumire = ? AND S.Nume = ?''',numecurs, numestud, stareprezenta, dataprezenta, motivare)
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
        cursor.execute(
            "UPDATE dbo.STUDENTI SET Adresa = ? , Data_Nastere = ?, Date_Contact = ? "
            "WHERE ID_Student = (SELECT DISTINCT S.ID_Student FROM STUDENTI S "
            "WHERE S.Nume = ?)",adresa, datanastere, datecontact, numestud)
        conn.commit()
        conn.close()

        conn = connection()
        cursor = conn.cursor()
        cursor.execute(
            "UPDATE dbo.PARTICIPARE_CURSURI "
            "SET Stare_Prezenta = ? , Data_Prezenta = ? , Motivare = ? "
            "WHERE ID_Student = (SELECT DISTINCT S.ID_Student FROM STUDENTI S WHERE S.Nume = ?) "
            "AND ID_Curs = (SELECT C.ID_Curs FROM CURS C WHERE C.Denumire = ?)",stareprezenta, dataprezenta, motivare, numestud, numecurs)
        conn.commit()
        conn.close()

        return redirect('/')

@app.route('/delete/<string:student_name>', methods=['GET','POST'])
def delete(student_name):
    conn = connection()
    cursor = conn.cursor()
    id_students_to_delete = cursor.execute('SELECT S.ID_Student FROM dbo.STUDENTI S WHERE S.Nume = ?' , student_name).fetchone()
    cursor.commit()

    # Delete Studenti
    cursor.execute('DELETE FROM dbo.PARTICIPARE_CURSURI WHERE ID_Student = ?' , id_students_to_delete)
    cursor.commit()
    cursor.execute('DELETE FROM dbo.STUDENTI WHERE ID_Student = ?' , id_students_to_delete)
    cursor.commit()
    cursor.close()
    return redirect(url_for('student_list'))

def connection():

    conn = pyodbc.connect('Driver={SQL Server};'
                          'Server=LAPTOP-DVKJQ5MD\SQLEXPRESS;'
                          'Database=Evidenta_Participare_Cursuri_Online;'
                          'Username=alexia'
                          'Password=alexia1'
                          'Trusted_Connection=yes;')
    return conn

users = {
    'alexia': 'alexia1',
}

if __name__ == "__main__":
    app.run(debug=True)
