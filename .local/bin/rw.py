#!/usr/bin/python
import json, subprocess
from pprint import pprint

outfile = '/home/runiales/.config/tareas/.taskwarrior.rem'

reminders = '# Taskwarrior Tasks with Due Dates\n'
for t in json.loads(subprocess.check_output(['task', 'rc:/home/runiales/.config/tareas/.taskrc', 'due.before:someday', '-COMPLETED', '-DELETED', '-TEMPLATE', 'export'])):
    reminders += ("REM %s-%s-%s MSG %s: %s\n" % (t['due'][:4],t['due'][4:6],t['due'][6:8],t['project'],t['description']))
    #reminders += ("REM %s-%s-%s@%s:%s MSG %s: %s\n" % (t['due'][:4],t['due'][4:6],t['due'][6:8],t['due'][9:11],t['due'][11:13],t['project'],t['description']))
    #hace falta que toda tarea con fecha tenga también proyecto

#print(reminders)

with open(outfile, 'r') as f:
    #compare file with reminders string
    if reminders != f.read():
        #write new file only if it differs from existing file
        with open(outfile, 'w') as o:
            o.write(reminders)
