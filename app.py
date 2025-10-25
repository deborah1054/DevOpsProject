from flask import Flask, render_template  # <-- We added 'render_template'
import os

app = Flask(__name__)

# This is the same as before
greeting = os.environ.get("GREETING", "Hello")

# This is your new homepage route
@app.route('/')
def home():
    # This tells Flask to find 'index.html' in the 'templates' folder.
    # It also passes the 'greeting' variable to the HTML.
    return render_template('index.html', greeting=greeting)

# This is your new "About" page route
@app.route('/about')
def about():
    # This tells Flask to find and show 'about.html'
    return render_template('about.html')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)