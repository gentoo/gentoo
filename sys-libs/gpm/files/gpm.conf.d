# /etc/init.d/gpm

# Please uncomment the type of mouse you have and the appropriate MOUSEDEV entry

MOUSE=ps2
#MOUSE=imps2
#MOUSEDEV=/dev/psaux
MOUSEDEV=/dev/input/mice

# Extra settings

#RESPONSIVENESS=
#REPEAT_TYPE=raw

# Please uncomment this line if you want gpm to understand charsets used
# in URLs and names with ~ or : in them, etc. This is a good idea to turn on!

#APPEND="-l \"a-zA-Z0-9_.:~/\300-\326\330-\366\370-\377\""

# Various other options, see gpm(8) manpage for more.

#APPEND="-g 1 -A60"
#APPEND="-l \"a-zA-Z0-9_.:~/\300-\326\330-\366\370-\377\" -g 1 -A60"
