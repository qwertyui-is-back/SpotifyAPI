from flask import Flask, request

app = Flask(__name__)

@app.route('/callback')
def callback():
	print('Code received! Press CTRL+C to exit.')
	return request.args.get('code')

if __name__ == '__main__':
	app.run(port = 80)
