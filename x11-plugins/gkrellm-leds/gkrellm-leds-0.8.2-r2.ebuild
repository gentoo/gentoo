# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gkrellm-plugin autotools

MY_P="${P/rellm-/}"

DESCRIPTION="GKrellM2 plugin for monitoring keyboard LEDs"
HOMEPAGE="http://heim.ifi.uio.no/~oyvinha/gkleds/"
SRC_URI="http://heim.ifi.uio.no/~oyvinha/e107_files/downloads/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~alpha amd64 ~ppc ~sparc x86"

RDEPEND="
	app-admin/gkrellm:2[X]
	x11-libs/libXtst"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${P}-r2-ldflags-typo.patch" )

src_prepare() {
	default
	eautoreconf
}

src_install() {
	PLUGIN_SO=( src/.libs/gkleds$(get_modname) )
	gkrellm-plugin_src_install
}
