# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Provide libnotify interface to Pidgin and Finch"
HOMEPAGE="http://purple-libnotify-plus.sardemff7.net/"
SRC_URI="https://github.com/sardemff7/purple-libnotify-plus/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	net-im/pidgin
	>=net-im/purple-events-0.99.1
	x11-libs/gdk-pixbuf
	>=x11-libs/libnotify-0.7.0"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

src_prepare() {
	default
	eautoreconf
}
