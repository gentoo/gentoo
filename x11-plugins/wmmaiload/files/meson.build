project('wmmaiload', 'c', version: '2.3.0')

add_project_arguments(
    '-DHAVE_THREADS',
    '-DHAVE_IMAP',
    '-DHAVE_MAILDIR',
    '-DHAVE_MBOX',
    '-DHAVE_MH',
    '-DHAVE_POP3',
    '-DHAVE_SSL',
    '-DHAVE_SELECT',
    '-DHAVE_STRING_H',
    '-DHAVE_STRINGS_H',
    '-DHAVE_UNISTD_H',
    language: 'c',
)

# Originally, this was generated and regenerated
# by a set of shell functions embedded into makefile
# replacing with sane defaults

add_project_arguments(
    '-DVERSION="2.3.0"',
    '-DAUTHORS="Thomas Nemeth"',
    '-DOSTYPE="linux"',
    '-DBUILD=""',
    language: 'c',
)

threads_dep = dependency('threads')
ssl = dependency('openssl')
xext = dependency('xext')
xpm = dependency('xpm')
gtk = dependency('gtk+-2.0')
x11 = dependency('X11')

wmmaiload_sources = [
    'wmmaiload/checkthread.c',
    'wmmaiload/dockapp.c',
    'wmmaiload/imapclient.c',
    'wmmaiload/main.c',
    'wmmaiload/options.c',
    'wmmaiload/pop3client.c',
    'wmmaiload/ssl.c',
]

wmmaiload_include = include_directories('wmmaiload')

wmmaiload = executable(
    'wmmaiload',
    wmmaiload_sources,
    include_directories: wmmaiload_include,
    dependencies: [threads_dep, ssl, xext, xpm],
    install: true,
    c_args: ['-DPACKAGE="WMMaiLoad"', '-DPROGRAM="wmmaiload"'],
)

wmmail_conf_sources = [
    'wmmaiload-config/actions.c',
    'wmmaiload-config/dialogs.c',
    'wmmaiload-config/main.c',
    'wmmaiload-config/mainwindow.c',
    'wmmaiload-config/popedit.c',
    'wmmaiload-config/tools.c',
]

wmmail_conf_include = include_directories('wmmaiload-config')

wmmail_conf = executable(
    'wmmaiload-config',
    wmmail_conf_sources,
    dependencies: [gtk, x11],
    include_directories: wmmail_conf_include,
    c_args: ['-DPACKAGE="WMMaiLoad-Config"', '-DPROGRAM="wmmaiload-config"'],
    install: true,
)

