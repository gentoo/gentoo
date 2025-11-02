# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xorg-3

MY_PN=${PN,,}
DESCRIPTION="Xaw3dXft library"
HOMEPAGE="https://github.com/DaveFlater/libXaw3dXft"
SRC_URI="https://github.com/DaveFlater/libXaw3dXft/releases/download/v${PV}/${MY_PN}-${PV}.tar.xz"
S="${WORKDIR}"/${MY_PN}-${PV}

KEYWORDS="amd64 x86"
IUSE="xpm"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXft
	x11-libs/libXmu
	x11-libs/libXt
	xpm? ( x11-libs/libXpm )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="
	app-alternatives/lex
	app-alternatives/yacc
	x11-misc/util-macros"

QA_PKGCONFIG_VERSION="${PV//[!0-9.]}"

src_configure() {
	local XORG_CONFIGURE_OPTIONS=(
		$(usev xpm --enable-multiplane-bitmaps)

		--enable-internationalization
		--enable-arrow-scrollbars
		--enable-gray-stipples
	)
	xorg-3_src_configure
}

src_install() {
	xorg-3_src_install

	rm -r "${ED}"/usr/share/doc/"${PF}"/README_pics/ || die
}
