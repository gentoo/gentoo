# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
EAUTORECONF=1
inherit xfconf

DESCRIPTION="Xfce panel plugin which allows to put the maximized window title and windows buttons on the panel"
HOMEPAGE="http://github.com/cedl38/xfce4-windowck-plugin"
SRC_URI="http://github.com/cedl38/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

RDEPEND=">=x11-libs/gtk+-2.20:2
	x11-libs/libX11
	>=x11-libs/libwnck-2.30:1
	>=xfce-base/libxfce4ui-4.10
	>=xfce-base/libxfce4util-4.10
	>=xfce-base/xfce4-panel-4.10
	>=xfce-base/xfconf-4.10"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	XFCONF=(
		$(xfconf_use_debug)
		)

	DOCS=( AUTHORS NEWS README TODO )
}

src_prepare() {
	# run xdt-autogen from xfce4-dev-tools added as dependency by EAUTORECONF=1 to
	# rename configure.ac.in to configure.ac while grabbing $LINGUAS and $REVISION values
	NOCONFIGURE=1 xdt-autogen

	xfconf_src_prepare
}
