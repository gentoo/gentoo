# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="The Compiz ICC colour server"
HOMEPAGE="https://github.com/compiz-reloaded"
EGIT_REPO_URI="https://github.com/compiz-reloaded/compicc.git"

LICENSE="GPL-2+"
SLOT="0"

RDEPEND="
	dev-libs/libxml2
	>=media-libs/oyranos-0.9.6
	>=x11-wm/compiz-${PV}
	x11-libs/libXinerama
	x11-libs/libXxf86vm
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-base/xorg-proto
"

DEPEND="${RDEPEND}
	app-doc/doxygen
	>=dev-util/intltool-0.35
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"
