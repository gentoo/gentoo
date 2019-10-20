# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A panel plug-in to display wireless interface statistics"
HOMEPAGE="https://goodies.xfce.org/projects/panel-plugins/xfce4-wavelan-plugin"
SRC_URI="https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ppc ~ppc64 x86"
IUSE="kernel_linux"

COMMON_DEPEND=">=xfce-base/libxfce4ui-4.12:=[gtk3(+)]
	>=xfce-base/xfce4-panel-4.12:="
RDEPEND="${COMMON_DEPEND}
	kernel_linux? ( sys-apps/net-tools )"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	# fix build failure w/ xfce4-panel-4.15.0
	# https://git.xfce.org/panel-plugins/xfce4-wavelan-plugin/commit/?id=c0033c32ec28bbdd5f735f9b52d212e881eb2219
	sed -i -e 's@<libxfce4panel/xfce-panel-plugin\.h>@<libxfce4panel/libxfce4panel.h>@' \
		panel-plugin/wavelan.c || die
	default
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
