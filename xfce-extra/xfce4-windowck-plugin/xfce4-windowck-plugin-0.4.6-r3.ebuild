# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
inherit autotools python-any-r1 xdg-utils

DESCRIPTION="Xfce plugin puts the maximized window title and windows buttons on the panel"
HOMEPAGE="https://github.com/cedl38/xfce4-windowck-plugin"
SRC_URI="https://github.com/cedl38/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.20:2
	x11-libs/libX11
	>=x11-libs/libwnck-2.30:1
	<xfce-base/libxfce4ui-4.15:=[gtk2(+)]
	>=xfce-base/libxfce4util-4.10:=
	<xfce-base/xfce4-panel-4.15:=[gtk2(+)]
	>=xfce-base/xfconf-4.10:="
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-util/intltool
	dev-util/xfce4-dev-tools
	media-gfx/imagemagick[png]
	sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	# run xdt-autogen from xfce4-dev-tools added as dependency by EAUTORECONF=1 to
	# rename configure.ac.in to configure.ac while grabbing $LINGUAS and $REVISION values
	NOCONFIGURE=1 xdt-autogen || die

	default
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
