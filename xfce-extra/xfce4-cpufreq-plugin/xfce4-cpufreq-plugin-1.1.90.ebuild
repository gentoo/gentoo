# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A panel plugin for showing information about cpufreq settings"
HOMEPAGE="https://goodies.xfce.org/projects/panel-plugins/xfce4-cpufreq-plugin"
SRC_URI="mirror://xfce/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.20:=
	>=x11-libs/gtk+-3.20:3=
	>=xfce-base/libxfce4ui-4.12:=[gtk3(+)]
	>=xfce-base/xfce4-panel-4.12:="
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}
