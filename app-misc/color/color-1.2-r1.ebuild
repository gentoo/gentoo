# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit eutils toolchain-funcs

DESCRIPTION="Easily add ANSI colouring to shell scripts"
HOMEPAGE="http://www.runslinux.net/?page_id=10"
SRC_URI="http://runslinux.net/projects/color/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ~ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${PV}-ldflags.patch
	tc-export CC
}

src_install() {
	dobin color || die "dobin failed"
	dodoc CHANGELOG README || die

	# symlink for british users.
	dosym color /usr/bin/colour || die
}

pkg_postinst() {
	elog "For information on using colour in your shell scripts,"
	elog "run \`color\` without any arguments."
	elog
	elog "To see all the colours available, use this command"
	elog "	$ color --list"
	elog
	elog "More examples are available in ${EPREFIX}/usr/share/doc/${PF}."
}
