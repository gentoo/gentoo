project('icclib', 'c', version: '2.14')

add_project_arguments('-DUNIX', language: 'c')

cc = meson.get_compiler('c')

math = cc.find_library('m', required: false)

icclib = library(
    'icc',
    'icc.c',
    soversion: '0',
    dependencies: math,
    install: true,
)

executable(
    'iccdump',
    ['iccdump.c', 'iccstd.c'],
    install: true,
    link_with: icclib,
    dependencies: math,
)
executable(
    'lutest',
    ['lutest.c', 'iccstd.c'],
    install: false,
    link_with: icclib,
    dependencies: math,
)
executable(
    'icclu',
    ['icclu.c', 'iccstd.c'],
    install: false,
    link_with: icclib,
    dependencies: math,
)
executable(
    'iccrw',
    ['iccrw.c', 'iccstd.c'],
    install: false,
    link_with: icclib,
    dependencies: math,
)
executable(
    'icctest',
    ['icctest.c', 'iccstd.c'],
    install: false,
    link_with: icclib,
    dependencies: math,
)
