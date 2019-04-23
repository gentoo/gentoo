# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="stuffit520.611linux-i386"

DESCRIPTION="Aladdin Software's StuffIt and StuffIt Expander"
HOMEPAGE="http://www.stuffit.com/"
SRC_URI="http://my.smithmicro.com/downloads/files/${MY_P}.tar.gz"

LICENSE="Stuffit"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
RESTRICT="fetch strip"

S="${WORKDIR}"

INSTALLDIR=/opt/stuffit

pkg_nofetch() {
	einfo "Please download stuffit from"
	einfo "${SRC_URI}"
	einfo "and place the file in your DISTDIR directory."
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
	dodoc doc/stuff/{README,stuff.html}
	docinto unstuff
	dodoc doc/unstuff/{README,unstuff.html}

	# And now the man pages
	doman man/man1/*

	# Also add the executables to the path
	dodir /etc/env.d
	cat > "${T}"/10stuffit <<- EOF || die
		PATH="${EPREFIX}${INSTALLDIR}/bin"
		ROOTPATH="${EPREFIX}${INSTALLDIR}/bin"
	EOF
	doenvd "${T}"/10stuffit
}

pkg_postinst() {
	elog
	elog "Reminder: StuffIt requires registration within 30 days."
	elog "The registration program is located in ${INSTALLDIR}/extra"
	elog
	elog "The binaries are named 'stuff' and 'unstuff'"
	elog
}
