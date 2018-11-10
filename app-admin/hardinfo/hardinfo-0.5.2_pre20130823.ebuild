# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="System information and benchmark tool for Linux systems"
HOMEPAGE="https://github.com/lpereira/hardinfo"
SRC_URI="https://dev.gentoo.org/~hasufell/distfiles/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	net-libs/libsoup
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
	x11-libs/pango"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
