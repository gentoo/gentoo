# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="diff-like program operating at word level instead of line level"
HOMEPAGE="https://os.ghalkes.nl/dwdiff.html"
SRC_URI="https://os.ghalkes.nl/dist/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc ~ppc64 x86"
IUSE="nls"

RDEPEND="
	dev-libs/icu:=
	sys-apps/diffutils"
DEPEND="${RDEPEND}"
BDEPEND="nls? ( sys-devel/gettext )"

PATCHES=( "${FILESDIR}"/${P}-C99-fix.patch )

src_prepare() {
	default
	sed -i -e '/INSTALL/s:COPYING::' Makefile.in || die
}

src_configure() {
	./configure \
		--prefix="${EPREFIX}"/usr \
		$(use_with nls gettext) || die
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}
