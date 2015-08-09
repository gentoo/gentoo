#!/bin/bash

# To use something besides `emerge` to install packages, set
# XCB_REBUILDER_INSTALL to that binary.

if ! . /lib/gentoo/functions.sh 2>/dev/null; then
	echo 'Please install sys-apps/gentoo-functions and rerun this script.'
	exit 1
fi

case ${1} in
	'') ;;
	*)
		einfo 'Rebuilds broken packages from the XCB library renaming'
		einfo
		einfo 'To use something besides `emerge`, set the INSTALL variable to their binary.'
		exit 1
		;;
esac

if ! type -p qfile >/dev/null; then
	einfo "Please install app-portage/portage-utils."
	exit 1
fi

if ! type -p scanelf >/dev/null; then
	einfo "Please install app-misc/pax-utils."
	exit 1
fi

einfo "Fixing broken libtool archives (.la)"
for i in $(qlist -a | grep "\.la$"); do
	sed -i \
		-e "s:[^[:space:]]*xcb-xlib[^[:space:]]*::g" \
		"${i}" 2>/dev/null
done

einfo "Scanning for libraries requiring libxcb-xlib.so..."
for i in $(qlist -a | grep "\.so$"); do
	scanelf -n $i \
	| grep -q xcb-xlib \
	&& XCB_LIBS="${XCB_LIBS} ${i}"
done

if [[ -n ${XCB_LIBS} ]]; then
	einfo "Broken libraries:"
	for lib in ${XCB_LIBS}; do
		echo "  ${lib}"
	done
	ebegin "Scanning for packages installing broken libraries"
	XCB_PACKAGES=$(qfile -qC ${XCB_LIBS} | sort | uniq)
	eend 0
else
	einfo "No broken libraries detected"
	exit 0
fi


einfo "Broken packages:"
for pkg in ${XCB_PACKAGES}; do
	echo "  ${pkg}"
done

echo
ewarn "Please read the libxcb upgrade guide for further instructions"
ewarn "http://www.gentoo.org/proj/en/desktop/x/x11/libxcb-1.4-upgrade-guide.xml"

#
#ebegin "Rebuilding broken packages"
#${XCB_REBUILDER_INSTALL:-emerge -1} ${XCB_PACKAGES}
#eend $?
