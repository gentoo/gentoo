# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

DESCRIPTION="Multiple Image Networkgraphics lib (animated png's)"
HOMEPAGE="https://www.libmng.com/"
SRC_URI="mirror://sourceforge/libmng/${P}.tar.xz"

LICENSE="libmng"
SLOT="0/2"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="lcms static-libs"

RDEPEND="
	>=sys-libs/zlib-1.2.8-r1[static-libs?,${MULTILIB_USEDEP}]
	>=virtual/jpeg-0-r2:0[static-libs?,${MULTILIB_USEDEP}]
	lcms? ( >=media-libs/lcms-2.5:2[static-libs?,${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-jpeg-9a.patch )

src_prepare() {
	emake distclean
	default
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
		--with-jpeg
		$(use_with lcms lcms2)
		--without-lcms
		)

	ECONF_SOURCE="${S}" \
		econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	dodoc CHANGES README* doc/{doc.readme,libmng.txt}
	doman doc/man/*.{3,5}
}
