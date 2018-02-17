# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Standard unix calendar program for Linux, ported from OpenBSD"
HOMEPAGE="http://bsdcalendar.sourceforge.net/"
SRC_URI="http://bsdcalendar.sourceforge.net/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 sparc x86"

DOCS=( README )

src_compile() {
	tc-export CC
	emake
}

src_install() {
	dobin "${PN}"
	doman "${PN}.1"

	insinto "/usr/share"
	doins -r "${PN}s"

	mv "${D}/usr/share/${PN}s" "${D}/usr/share/${PN}" || die

	einstalldocs
}
