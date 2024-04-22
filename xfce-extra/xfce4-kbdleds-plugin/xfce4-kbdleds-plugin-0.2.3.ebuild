# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools xdg-utils

DESCRIPTION="A panel plug-in to show state of Caps, Num and Scroll Lock keys"
HOMEPAGE="https://github.com/oco2000/xfce4-kbdleds-plugin"
SRC_URI="https://dev.gentoo.org/~mgorny/dist/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

DEPEND="
	xfce-base/libxfce4ui:=
	xfce-base/libxfce4util:=
	xfce-base/xfce4-panel
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"
# for eautoreconf
BDEPEND+="
	dev-build/xfce4-dev-tools
"

PATCHES=(
	# https://github.com/oco2000/xfce4-kbdleds-plugin/pull/7
	"${FILESDIR}/${P}-xfce-4.16.patch"
	# https://github.com/oco2000/xfce4-kbdleds-plugin/pull/10
	"${FILESDIR}/${P}-x11-libs.patch" #913681
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
