# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit multilib xfconf

DESCRIPTION="a compatibility layer for running WindowMaker dockapps on Xfce4"
HOMEPAGE="http://goodies.xfce.org/projects/panel-plugins/xfce4-wmdock-plugin"
SRC_URI="mirror://xfce/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd"
IUSE="debug"

RDEPEND="x11-libs/gtk+:2
	>=xfce-base/libxfce4util-4.10
	>=xfce-base/libxfcegui4-4.10
	>=xfce-base/xfce4-panel-4.10
	>=x11-libs/libwnck-2.8.1:1
	x11-libs/libX11"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	PATCHES=( "${FILESDIR}"/${P}-LINGUAS.patch )

	XFCONF=(
		--libexecdir="${EPREFIX}"/usr/$(get_libdir)
		$(xfconf_use_debug)
		)

	DOCS=( AUTHORS ChangeLog README TODO )
}

src_prepare() {
	echo panel-plugin/wmdock.desktop.in.in >> po/POTFILES.skip
	xfconf_src_prepare
}
