# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Expander is a utility that acts as a filter for text editors"
HOMEPAGE="http://www.nedit.org"
SRC_URI="ftp://ftp.nedit.org/pub/contrib/misc/nedit_expander_kit_2.05.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-linux ~ppc-macos"

S="${WORKDIR}/${PN}"

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_compile() {
	emake -C src CC=$(tc-getCC)
}

src_install() {
	dobin src/{expander,boxcomment,align_columns,align_comments,where_is}
	dosym boxcomment /usr/bin/unboxcomment

	einstalldocs
	dodoc USAGE
	doman docs/*.1

	insinto /usr/share/${P}
	doins -r service defs macros misc templates
}

pkg_postinst() {
	elog
	elog "Instructions for using expander with NEdit are in /usr/share/doc/${PF}/INSTALL"
	elog "Macro, definition and template files can be found in /usr/share/${P}"
	elog
}
