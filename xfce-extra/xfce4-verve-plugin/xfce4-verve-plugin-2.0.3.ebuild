# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A comfortable command line plugin for the Xfce panel"
HOMEPAGE="
	https://goodies.xfce.org/projects/panel-plugins/xfce4-verve-plugin/
	https://gitlab.xfce.org/panel-plugins/xfce4-verve-plugin/
"
SRC_URI="https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"

DEPEND="
	dev-libs/glib:2
	>=dev-libs/libpcre-5:=
	>=xfce-base/libxfce4ui-4.12:=
	>=xfce-base/xfce4-panel-4.12:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-util/intltool
	virtual/pkgconfig
"

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
