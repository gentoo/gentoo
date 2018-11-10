#!/bin/sh
# run like this: ocaml-rebuild.sh [-h | -f] [emerge_options]

emerge=/usr/bin/emerge

if [ "$1" = "-h" ]
then
	echo "usage: ocaml-rebuild.sh [-h | -f(orce)] [emerge_options]"
	echo "With -f, 	the packages will first be unmerged and then emerged"
	echo "with the given options to ensuree correct dependancy analysis."
	echo "Otherwise emerge is run with the --pretend flag and the given"
	echo "options."
	echo "It is recommended to keep the list of rebuilt packages printed"
	echo "in pretend mode in case something go wrong"
	exit 1
fi

if [ "$1" = "-f" ]
then
	pretend=0
	shift
else
	pretend=1
fi

depends=`find /var/db/pkg -name DEPEND -exec grep -l 'dev-lang/ocaml\\|dev-ml/findlib' {} \;`

for dep in $depends
do 
  dir=`dirname $dep`
  pkg=`basename $dir`
  category=`cat $dir/CATEGORY`
  slot=`cat $dir/SLOT`

  tobuild=">=$category/$pkg:$slot $tobuild"
  tobuildstr="\">=$category/$pkg:$slot\" $tobuildstr"
done

if [ "$tobuild" = "" ] ; then
	echo "Nothing to do!"
	exit 0
fi

echo Building $tobuildstr

if [ $pretend -eq 1 ]
then
	$emerge --pretend $@ $tobuild
else
	$emerge --oneshot $@ $tobuild
fi
