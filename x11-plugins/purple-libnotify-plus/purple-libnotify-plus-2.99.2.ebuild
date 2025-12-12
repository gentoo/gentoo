# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Provide libnotify interface to Pidgin and Finch"
HOMEPAGE="https://github.com/sardemff7/purple-libnotify-plus"
SRC_URI="https://github.com/sardemff7/purple-libnotify-plus/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/glib:2
	net-im/pidgin
	>=net-im/purple-events-0.99.1
	x11-libs/gdk-pixbuf:2
	>=x11-libs/libnotify-0.7.0
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )
