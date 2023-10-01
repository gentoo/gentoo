# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Disk Information Utility"
HOMEPAGE="https://diskinfo-di.sourceforge.io/"
SRC_URI="mirror://sourceforge/diskinfo-di/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="nls"

RESTRICT="test" #405205, #405471

BDEPEND="nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${PN}-4.33-build.patch
)

src_configure() {
	emake checkbuild
	emake -C C config.h
}

src_compile() {
	emake prefix="${EPREFIX}"/usr CC="$(tc-getCC)" NLS=$(usex nls T F)
}

src_install() {
	emake install prefix="${ED}"/usr
	# default symlink is broken
	dosym di /usr/bin/mi
	dodoc README.txt
}
