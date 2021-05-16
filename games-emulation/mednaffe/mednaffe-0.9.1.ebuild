# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg

DESCRIPTION="Front-end (GUI) for mednafen emulator"
HOMEPAGE="https://github.com/AmatCoder/mednaffe/"
SRC_URI="https://github.com/AmatCoder/mednaffe/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-libs/glib:2
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3"
RDEPEND="
	${DEPEND}
	>=games-emulation/mednafen-1.22.1"
BDEPEND="virtual/pkgconfig"
