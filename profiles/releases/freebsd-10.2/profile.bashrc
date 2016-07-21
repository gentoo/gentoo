# Copyright 1999-2015 Gentoo Foundation.
# Distributed under the terms of the GNU General Public License, v2
# $Id$

bsd-fbsd10fix(){
	# http://svnweb.freebsd.org/ports/head/Mk/bsd.port.mk
	
	for f in `find ${WORKDIR} -type f \( -name config.libpath -o \
		-name config.rpath -o -name configure -o -name libtool.m4 -o \
		-name ltconfig -o -name libtool -o -name aclocal.m4 -o \
		-name acinclude.m4 \)` ; do \
			sed -i.fbsd10bak \
				-e 's|freebsd1\*)|freebsd1.\*)|g' \
				-e 's|freebsd\[12\]\*)|freebsd[12].*)|g' \
				-e 's|freebsd\[123\]\*)|freebsd[123].*)|g' \
				-e 's|freebsd\[\[12\]\]\*)|freebsd[[12]].*)|g' \
				-e 's|freebsd\[\[123\]\]\*)|freebsd[[123]].*)|g' \
					${f} ; \
			touch -mr ${f}.fbsd10bak ${f} ; \
			rm -f ${f}.fbsd10bak ; \
			einfo "===>   FreeBSD 10 autotools fix applied to ${f}"; \
	done
}

if [[ -n $EAPI ]] ; then
	case "$EAPI" in
		0|1)
			post_src_unpack() { bsd-patch_install-sh ; bsd-fbsd10fix ; }
			;;
		*)
			post_src_prepare() { bsd-patch_install-sh ; bsd-fbsd10fix ; }
			;;
	esac
fi

