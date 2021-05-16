# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="An in-depth exploration of the art of shell scripting"
HOMEPAGE="https://www.tldp.org/LDP/abs/html"

SRC_URI="http://bash.deta.in/abs-guide-final.tar.bz2
	pdf? ( http://bash.deta.in/abs-guide.pdf )"
S="${WORKDIR}"/abs

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ~mips ppc sparc x86"
IUSE="pdf"

src_unpack() {
	unpack abs-guide-final.tar.bz2

	if use pdf ; then
		cp "${DISTDIR}"/abs-guide.pdf "${S}" || die
	fi
}

src_install() {
	dodoc -r *
	docompress -x /usr/share/doc/${PF}
}

pkg_postinst() {
	elog "The HTML docs can be accessed through ${EROOT}/usr/share/doc/${PF}/HTML/index.html"
	elog "Example scripts from the book are installed in ${EROOT}/usr/share/doc/${PF}/"
	use pdf && elog "along with the pdf version."
}
