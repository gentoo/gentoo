# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Smart bookmark plug-in for the Xfce desktop environment"
HOMEPAGE="https://goodies.xfce.org/projects/panel-plugins/xfce4-smartbookmark-plugin"
SRC_URI="https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

COMMON_DEPEND=">=xfce-base/libxfce4ui-4.12:=[gtk3(+)]
	>=xfce-base/xfce4-panel-4.12:="
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS README )

src_prepare() {
	# substitute default bugtracker
	sed -i -e '/bugs/s:bugs\.debian:bugs.gentoo:' src/smartbookmark.c || die
	# fix build failure w/ xfce4-panel-4.15.0
	# https://git.xfce.org/panel-plugins/xfce4-smartbookmark-plugin/commit/?id=856d73b51f5d237d3cf6792f5e9f55220e5facf1
	sed -i -e 's@<libxfce4panel/xfce-panel-plugin\.h>@<libxfce4panel/libxfce4panel.h>@' \
		src/smartbookmark.c || die
	default
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
