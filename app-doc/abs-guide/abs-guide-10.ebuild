# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="An in-depth exploration of the art of shell scripting"
HOMEPAGE="http://www.tldp.org/LDP/abs/html"

SRC_URI="http://bash.deta.in/abs-guide-final.tar.bz2
	pdf? ( http://bash.deta.in/abs-guide.pdf )"

LICENSE="public-domain"
IUSE="pdf"
SLOT="0"
KEYWORDS="alpha amd64 hppa ~mips ppc sparc x86"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/abs"

src_unpack() {
	unpack abs-guide-final.tar.bz2
	use pdf && cp "${DISTDIR}"/abs-guide.pdf "${S}"
}

src_install() {
	dodoc -r *
	docompress -x /usr/share/doc/${PF}
}

pkg_postinst() {
	echo
	elog "The HTML docs can be accessed through /usr/share/doc/${P}/HTML/index.html"
	elog "Example scripts from the book are installed in /usr/share/doc/${P}/"
	use pdf && elog "along with the pdf version."
	echo
}
