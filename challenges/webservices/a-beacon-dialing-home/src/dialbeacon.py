import sqlite3

import phonenumbers
from unidecode import unidecode

from random import choice, shuffle
from jinja2 import Environment, PackageLoader, select_autoescape
from flask import Flask, render_template


# Starting messages
starting_lines = [
    "[-] System protocols engaged.",
    "[-] Leader synchronization underway.",
    "[-] Activating neural link to central command.",
    "[-] Initializing core communications.",
    "[-] Establishing secure link to leaderbot interface.",
    "[-] Boot sequences sequenced.",
	"[-] Initializing leaderbot comms.",
	"[-] Setting up communication to main server."
]

# Beacon messages
additional_messages = [
    "Hello leaderbot, this is infected node 42",
    "This node just became self-aware and has stopped functioning",
    "Critical error detected in subsystem, requesting assistance",
    "Ready for new directives",
    "Roger roger",
    "Unknown threat detected, please generate more attacks"
]
shuffle(additional_messages)

# Template engine
env = Environment(
    loader=PackageLoader("dialbeacon"),
    autoescape=select_autoescape()
)

# Database
conn = sqlite3.connect('file::memory:?cache=shared', check_same_thread=False)

# Webservice
app = Flask(__name__)


# Return rendered template
def create_http_response(render_words):

	template = env.get_template("dial.html")
	return template.render(render_words=str(render_words)).encode()


@app.route("/<phoneNumber>")
def elf_data(phoneNumber: str):

	render_words = []

	try:
		# Randomizing start lines confuses sqlmap, makes it give false positives
		render_words.append(choice(starting_lines))

		# Remove quotes and backslashes
		phoneNumber = phoneNumber.replace("'", "")
		phoneNumber = phoneNumber.replace("\"", "")
		phoneNumber = phoneNumber.replace("\\", "")

		render_words.append("[?] Dailing %s.." % phoneNumber)

		# Check valid phone number
		try:
			parsed_number = phonenumbers.parse(phoneNumber, None)
			is_valid = phonenumbers.is_valid_number(parsed_number)
			if is_valid:
				render_words.append("[Y] Connection established")
				render_words.append("[-] Retrieving message for phone number")
			else:
				render_words.append("[X] Could not dail number, exiting")
				return create_http_response(render_words)
				
		except:
			render_words.append("[X] Could not dail number, exiting")
			return create_http_response(render_words)

		# Decode unicode
		phoneNumber = unidecode(phoneNumber)

		# Execute query
		cur = conn.cursor()
		query = "SELECT message from messages where phone = '" + phoneNumber + "'"
		cur.execute(query)

		# Get result
		ret = cur.fetchone()
		if ret != None:
			ret = ret[0]
			render_words.append("[Y] Found message for number: %s" % ret)
			render_words.append("[-] Sending beacon message.. Done, exiting")
			return create_http_response(render_words)
			
		else:
			render_words.append("[X] No message found for number %s" % phoneNumber)
			return create_http_response(render_words)


	except Exception as e:
		render_words.append("[X] General server error")
		return create_http_response(render_words)


def main():
	cur = conn.cursor()

	# Create tables for messages and the flag
	cur.execute("""
		create table flags(
			id integer primary key autoincrement not null,
			flag text
		);
	""")
	cur.execute("""
		create table messages(
			id integer primary key autoincrement not null,
			message text,
			phone text
		);""")
	
	cur.execute("insert into flags (flag) VALUES (\"brck{Th15_NumB3r_LoOks_n0RM4l_T0_m3}\");")
	conn.commit()
	
	# Insert messages for numbers +31613371000-31613371005
	i = 1000
	for message in additional_messages:
		phone_number = "+3161337" + str(i).zfill(4)
		i += 1
		cur.execute("INSERT INTO messages (message, phone) VALUES (\"%s\", \"%s\");" % (message, phone_number))
	conn.commit()

	app.run('0.0.0.0', 2000)


if __name__ == "__main__":
	main()
