#!/usr/bin/python

import sys, random

inputstr = sys.stdin.read()
input = inputstr.split()

class MarkovWord:
	def __init__(self, word):
		self.word = word
		self.childs = []

	def addchild(self, child):
		self.childs.append(child)

	def getachild(self):
		if (len(self.childs) > 0):
			return random.choice(self.childs)
		else:
			return None

	def __repr__(self):
		return self.word

	def __str__(self):
		return self.word

defs = {}
prev = defs[''] = root = MarkovWord('')
defs['.'] = tail = MarkovWord('.')
tail.addchild(root)

for i in input:
	s = i.lower().strip('."\'')
	if s not in defs:
		defs[s] = MarkovWord(s)
	if i[-1:] == '.':
		defs[s].addchild(tail)
		prev = root
	else:
	        prev.addchild(defs[s])
		prev = defs[s]

curr = root.getachild()
newsentence = []

limit = int(sys.argv[1])

while limit > 0 :
	newsentence.append(curr)
	curr = curr.getachild()
	if curr == None:
		curr == tail
	if curr == tail:
		limit-=1

newsentence.append(tail)

output = ''

for aword in newsentence:
	if aword == root:
		pass
	elif aword == tail:
		output += '. '
	else:
		output += ' %s' % aword	

print output[1:]
