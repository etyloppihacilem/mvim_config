import sys
import os
from datetime import datetime

def get_basename(filename):
	"""
	Get basename of a file
	"""
	return os.path.basename(filename)

def get_extension(filename):
	"""
	Get extension of a file
	if no extension found, whole name is returned
	"""
	return os.path.splitext(filename)[1][1:]

def which_comments(filename):
	"""
	Gets what type of comments to use.
	If comments are multiples lines, returns an array of opening and closing symbols
	"""
	default = ["#"]
	table = [
		[["py", "sh"], ["#"]],
		[["h", "hpp", "c", "cpp", "js", "php"], ["/*", "*/"]],
		[["html"], ["<!--", "-->"]],
		[["vdh", "lua"], ["--"]],
		[["vim"], ["\""]],
	]
	name = get_extension(filename)
	for ext, com in table:
		if name in ext:
			return (com)
	return (default)

def check_header(filename, comment):
	"""Returns true if header already in place"""
	with open(filename, "r") as f:
		if len(comment) == 1:
			for _ in range(9):
				a = f.readline()[:len(comment[0])]
				if a != comment[0]:
					return (False);
			return (True)
		if f.readline()[:len(comment[0])] != comment[0]:
			return (False)
		for _ in range(7):
			a = f.readline()
			if comment[1] in a:
				return (False)
		a = f.readline()[-2::-1][:len(comment[1])]
		if a != comment[1][::-1]:
			return (False)
		return (True)
	return (True)

def gen_header(filename, comment):
	"""
	Generate header list
	"""
	WHALE = [
		'       """  ',
        "-\\-    _|__",
		" |\\___/  . \\",
		" \\     /(((/",
		"  \\___/)))/ "
	]
	ret = []
	ret.append(comment[0] + " " + "#" * (WIDTH - (1 + len(comment[0]))))
	if len(comment) == 1:
		ret.append(comment[0])
	else:
		ret.append("")
	begining = ""
	if len(comment) == 1:
		begining = comment[0]
	for i in range(5):
		text = ""
		if (i == 0):
			text = " " * 8 + get_basename(filename)
		if (i == 2):
			text = " " * 8 + datetime.now().strftime("Created on %d %b. %Y at %H:%M")
		if (i == 3):
			text = " " * 8 + "by " + NAME
		if (i == 4):
			text = " " * 8 + EMAIL
		ret.append(begining + " " * (8 - len(begining)) + WHALE[i] + text)
	if len(comment) == 1:
		ret.append(comment[0])
	else:
		ret.append("")
	if len(comment) == 1:
		ret.append(comment[0] + " " + "#" * (WIDTH - (1 + len(comment[0]))))
	else:
		ret.append("#" * (WIDTH - (1 + len(comment[0]))) + " " + comment[1])
	ret.append("")
	return ([i + "\n" for i in ret])

def apply_header(filename, comment):
	"""Writes header to a file"""
	with open(filename, "r+") as f:
		old = f.readlines()
		f.seek(0)
		gen = gen_header(filename, comment)
		f.writelines(gen + old)

def run_header(filename):
	"""Checks for header then applies it if not there"""
	try:
		with open(filename) as f:
			pass
	except FileNotFoundError:
		print("File", filename, "not found, creating...")
		with open(filename, "w") as f:
			pass
	comment = which_comments(filename)
	done = check_header(filename, comment)
	if not done:
		print("Adding header to", filename)
		apply_header(filename, comment)
	else:
		print("Already in file", filename)

# main

NAME = "hmelica"
EMAIL = "hmelica@student.42.fr"
WIDTH = 120

if __name__ == "__main__":
	if (len(sys.argv) <= 1):
		print("Usage:", sys.argv[0], "filename")
		exit()
	for i in range(1, len(sys.argv)):
		run_header(sys.argv[i])
