# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit xfconf

DESCRIPTION="An mount plug-in for the Xfce panel"
HOMEPAGE="https://goodies.xfce.org/projects/panel-plugins/xfce4-mount-plugin"
SRC_URI="mirror://xfce/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND=">=xfce-base/libxfce4ui-4.10
	>=xfce-base/xfce4-panel-4.10"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	PATCHES=( "${FILESDIR}"/${P}-LINGUAS.patch )

	XFCONF=(
		$(xfconf_use_debug)
		)

	DOCS=( AUTHORS ChangeLog NEWS README TODO )
}
