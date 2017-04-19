# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
EAUTORECONF=yes
inherit xfconf

# git clone -b thunarx-2 git://git.xfce.org/thunar-plugins/thunar-shares-plugin

DESCRIPTION="Thunar plugin to share files using Samba"
HOMEPAGE="https://goodies.xfce.org/projects/thunar-plugins/thunar-shares-plugin"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="debug"

RDEPEND=">=dev-libs/glib-2.18
	>=x11-libs/gtk+-2.12:2
	>=xfce-base/thunar-1.2"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

pkg_setup() {
	XFCONF=(
		--disable-static
		$(xfconf_use_debug)
		)

	DOCS=( AUTHORS ChangeLog NEWS README TODO )
}

src_prepare() {
	# https://bugzilla.xfce.org/show_bug.cgi?id=10032
	sed -i -e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.in || die
	xfconf_src_prepare
}
