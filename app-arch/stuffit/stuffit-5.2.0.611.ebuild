# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

MY_P="stuffit520.611linux-i386"
DESCRIPTION="Aladdin Software's StuffIt and StuffIt Expander"
HOMEPAGE="http://www.stuffit.com/"
SRC_URI="http://my.smithmicro.com/downloads/files/stuffit520.611linux-i386.tar.gz"

LICENSE="Stuffit"
SLOT="0"
KEYWORDS="-* x86 amd64"
IUSE=""
RESTRICT="fetch strip"

S="${WORKDIR}"

INSTALLDIR="/opt/stuffit"

pkg_nofetch() {
	einfo "Please download stuffit from"
	einfo "${SRC_URI}"
	einfo "and put the file in ${DISTDIR}"
	einfo
	einfo "Note that StuffIt requires registration within 30 days,"
	einfo "but StuffIt Expander is freeware."
	einfo
}

src_install() {

	# First do the binaries
	exeinto ${INSTALLDIR}/bin
	doexe bin/stuff
	doexe bin/unstuff

	# Now the registration binary
	exeinto ${INSTALLDIR}/extra
	doexe bin/register

	# Now the documentation
	docinto stuff
	dodoc doc/stuff/README
	dohtml doc/stuff/stuff.html
	docinto unstuff
	dodoc doc/unstuff/README
	dohtml doc/unstuff/unstuff.html

	# And now the man pages
	doman man/man1/*

	# Also add the executables to the path
	dodir /etc/env.d
	echo -e "PATH=${INSTALLDIR}/bin\nROOTPATH=${INSTALLDIR}/bin" > \
		"${D}"/etc/env.d/10stuffit

}

pkg_postinst() {
	elog
	elog "Reminder: StuffIt requires registration within 30 days."
	elog "The registration program is located in ${INSTALLDIR}/extra"
	elog
	elog "The binaries are named 'stuff' and 'unstuff'"
	elog
}
