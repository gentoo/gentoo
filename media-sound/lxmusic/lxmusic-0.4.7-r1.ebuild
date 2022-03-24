# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A simple GUI XMMS2 client with minimal functionality"
HOMEPAGE="https://wiki.lxde.org/en/LXMusic"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-sound/xmms2
	x11-libs/gtk+:2
	x11-libs/libnotify"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"
