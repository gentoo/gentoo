# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit xfconf

DESCRIPTION="Task Manager"
HOMEPAGE="https://goodies.xfce.org/projects/applications/xfce4-taskmanager"
SRC_URI="mirror://xfce/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="debug gksu"

RDEPEND="x11-libs/cairo
	>=x11-libs/gtk+-2.12:2
	x11-libs/libwnck:1
	gksu? ( x11-libs/libgksu:2 )"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	PATCHES=(
		"${FILESDIR}"/${PN}-1.0.0-UTF-8.patch
		)

	XFCONF=(
		--enable-wnck
		$(use_enable gksu)
		$(xfconf_use_debug)
		)

	DOCS=( AUTHORS ChangeLog NEWS README THANKS )
}
