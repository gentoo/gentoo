#!/usr/bin/python
# Simple Python extension module doc generator.
# @(#) $Id$
# Written by Yeti <yeti@physics.muni.cz>
# This program is in the public domain.
import re, sys, types, inspect
from cgi import escape as q

args = sys.argv
args.pop(0)
if not args: sys.exit(0)

selfcontained = False
if args[0].startswith('-') and 'selfcontained'.startswith(args[0].strip('-')):
    selfcontained = True
    args.pop(0)
if not args: sys.exit(0)
modname = args.pop(0)
plain_docs = args

html_head = """\
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
    "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head><title>%s %s</title></head>
<body>
"""

html_foot = """\
</body>
</html>
"""

def split_para(doc):
    p = []
    for x in doc.split('\n\n'):
        x = x.strip()
        if x.find('\n>>>') > -1:
            h, t = x.split('\n>>>', 1)
            p.append(h)
            p.append('>>>' + t)
        else:
            p.append(x)
    return p

def get_doc(members):
    try: doc = members['__doc__']
    except KeyError: pass
    if doc: return doc
    try: doc = 'Python module %s' % members['__name__']
    except KeyError: pass
    if doc: return doc
    else: return 'A Python module'

def format_synopsis(synopsis, link=False, classname=None):
    lst = synopsis.split('\n')
    for i, s in zip(range(len(lst)), lst):
        m = re.match(r'(?P<func>\w+)(?P<args>.*)', s)
        args = re.sub(r'([a-zA-Z]\w+)', r'<var>\1</var>', m.group('args'))
        func = m.group('func')
        if link:
            if classname:
                func = '<a href="#%s-%s">%s</a>' % (classname, func, func)
            else:
                func = '<a href="#%s">%s</a>' % (func, func)
        lst[i] = func + args
    return '<br/>\n'.join(lst)

def format_para(p):
    if not p: return ''
    doc = ''
    if p.startswith('>>>'): doc += '<pre>\n%s\n</pre>\n' % q(p)
    else:
        if not re.search('^- ', p, re.M): doc += '<p>%s</p>\n' % q(p)
        else:
            p = re.split('(?m)^- ', p)
            if p[0]: doc += '<p>%s</p>\n' % q(p[0].strip())
            del p[0]
            doc += ('<ul>%s</ul>\n'
                    % '\n'.join(['<li>%s</li>' % q(p.strip()) for p in p]))
    return doc

def preprocess_routine(name, doc):
    parts = split_para(doc)
    if parts: summary = parts.pop(0)
    else: summary = 'FIXME'
    if parts and re.match(r'\w+\(.*\)', parts[0]): synopsis = parts.pop(0)
    else: synopsis = name + '()'
    return {'synopsis': synopsis, 'summary': summary, 'details': parts}

def analyse(obj):
    members = obj.__dict__
    if inspect.isclass(obj):
        main_doc = preprocess_routine(obj.__name__, get_doc(members))
        bases = [x.__name__ for x in obj.__bases__]
    else:
        main_doc = split_para(get_doc(members))
        bases = []
    routines = {}
    classes = {}
    data = {}
    for name, m in members.items():
        if name.startswith('__'): continue
        try:
            mro = list(inspect.getmro(m))
            if mro[0] != m: continue
        except AttributeError: pass
        if inspect.isroutine(m):
            try: doc = m.__doc__
            except KeyError: pass
            if not doc: doc = 'FIXME'
            routines[name] = preprocess_routine(name, doc)
            continue
        if inspect.isclass(m):
            classes[name] = analyse(m)
            continue
        t = type(m)
        if t == types.IntType or t == types.StringType:
            data[name] = repr(m)
        else:
            data[name] = m.__doc__
    return {'name': obj.__name__, 'doc': main_doc, 'routines': routines,
            'classes': classes, 'data': data, 'bases': bases}

def format(tree, level, prefix=''):
    name = tree['name']
    if prefix: fullname = '%s-%s' % (prefix, name)
    else: fullname = name
    ##### Main doc
    doc = []
    if level > 1:
        doc = ['<h%d id="%s">' % (level, fullname)]
        try: doc.append(format_synopsis(tree['doc']['synopsis']))
        except TypeError:
            doc.append(name)
        doc.append('</h%d>\n' % level)
        if tree.has_key('bases'):
            doc.append('<p>Bases: %s.</p>\n' % ', '.join(tree['bases']))
    try: lst = [tree['doc']['summary']] + tree['doc']['details']
    except TypeError: lst = tree['doc']
    for p in lst: doc.append(format_para(p))
    ##### Table of contents
    routines = tree['routines'].keys()
    classes = tree['classes'].keys()
    data = tree['data'].keys()
    if routines:
        routines.sort()
        if level == 1: doc.append('<p><b>Functions:</b></p>\n')
        else: doc.append('<p><b>Methods:</b></p>\n')
        doc.append('<ul class="ltoc">\n')
        for r in routines:
            synopsis = tree['routines'][r]['synopsis']
            doc.append('<li>%s</li>\n' % format_synopsis(synopsis, True,
                                                         fullname))
        doc.append('</ul>\n')
    if classes:
        classes.sort()
        doc.append('<p><b>Classes:</b></p>\n')
        doc.append('<ul class="ltoc">\n')
        for r in classes:
            synopsis = tree['classes'][r]['doc']['synopsis']
            doc.append('<li>%s</li>\n' % format_synopsis(synopsis, True,
                                                         fullname))
        doc.append('</ul>\n')
    if data:
        data.sort()
        doc.append('<p><b>Data:</b></p>\n')
        doc.append('<ul class="ltoc">\n')
        for r in data:
            doc.append('<li>%s = %s</li>\n' % (r, q(tree['data'][r])))
        doc.append('</ul>\n')
    ##### Functions
    if routines:
        if level == 1: doc.append('<hr/>\n')
        doc.append('<dl>\n')
        for r in routines:
            doc.append('<dt id="%s-%s">' % (fullname, r))
            rt = tree['routines'][r]
            doc.append('%s</dt>\n<dd>' % format_synopsis(rt['synopsis']))
            for p in [rt['summary']] + rt['details']:
                doc.append(format_para(p))
            doc.append('</dd>\n')
        doc.append('</dl>\n')
    ##### Classes
    if classes:
        for r in classes:
            doc.append('<hr/>\n')
            doc.append(format(tree['classes'][r], level+1, fullname))
    return ''.join(doc)

exec 'import %s as __test__' % modname
doctree = analyse(__test__)
document = format(doctree, 1)
print modname + '.html'
fh = file(modname + '.html', 'w')
if selfcontained: fh.write(html_head % (modname, 'module API'))
fh.write(document)
if selfcontained: fh.write(html_foot)
fh.close()
for f in plain_docs:
    try: fh = file(f, 'r')
    except: continue
    document = fh.read()
    fh.close()
    print f + '.xhtml'
    fh = file(f + '.xhtml', 'w')
    if selfcontained: fh.write(html_head % (modname, f))
    fh.write('<h1>%s %s</h1>\n\n' % (modname, f))
    fh.write('<pre class="main">\n')
    fh.write(document)
    fh.write('</pre>\n')
    if selfcontained: fh.write(html_foot)
    fh.close()
