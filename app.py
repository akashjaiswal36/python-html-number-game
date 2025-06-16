from flask import Flask, render_template, request, redirect, url_for, session
import random

app = Flask(__name__)
app.secret_key = 'secret-key'

@app.route('/', methods=['GET', 'POST'])
def index():
    if 'number' not in session:
        session['number'] = random.randint(1, 100)
        session['attempts'] = 0

    message = ''
    if request.method == 'POST':
        try:
            guess = int(request.form['guess'])
        except ValueError:
            message = 'Please enter a valid number.'
            return render_template('index.html', message=message, attempts=session['attempts'])

        session['attempts'] += 1
        number = session['number']
        if guess < number:
            message = 'Too low!'
        elif guess > number:
            message = 'Too high!'
        else:
            message = '🎉 Correct! You guessed it in {} attempts.'.format(session['attempts'], session['guess'])

    return render_template('index.html', message=message, attempts=session['attempts'])

@app.route('/reset')
def reset():
    session.pop('number', None)
    session.pop('attempts', None)
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
