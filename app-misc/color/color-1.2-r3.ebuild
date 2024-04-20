# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Easily add ANSI colouring to shell scripts"
HOMEPAGE="http://www.runslinux.net/?page_id=10"
SRC_URI="http://runslinux.net/projects/color/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~mips ppc ppc64 ~sparc x86"

src_prepare() {
	default
	# just rely on implicit rules
	rm Makefile || die
}

src_configure() {
	tc-export CC
}

src_compile() {
	emake color
}

src_install() {
	dobin color
	einstalldocs
}

pkg_postinst() {
	elog "For information on using colour in your shell scripts,"
	elog "run 'color' without any arguments."
	elog
	elog "To see all the colours available, use this command"
	elog "	$ color --list"
	elog
	elog "More examples are available in ${EROOT}/usr/share/doc/${PF}."
}
