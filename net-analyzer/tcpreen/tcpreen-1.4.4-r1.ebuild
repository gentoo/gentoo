# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="TCP network re-engineering tool"
HOMEPAGE="https://www.remlab.net/tcpreen/"
SRC_URI="https://www.remlab.net/files/${PN}/stable/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="nls"

BDEPEND="nls? ( sys-devel/gettext )"

PATCHES=( "${FILESDIR}"/${P}-literal-suffix.patch )

src_configure() {
	econf $(use_enable nls)
}

src_compile() {
	emake AR="$(tc-getAR)"
}
