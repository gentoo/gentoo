# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Window Maker dock app client for mpd (Music Player Daemon)"
HOMEPAGE="https://github.com/yogsothoth/wmmp"
SRC_URI="https://github.com/yogsothoth/wmmp/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 sparc x86"

RDEPEND="x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}"

src_install() {
	doman "${CMAKE_USE_DIR}/doc/WMmp.1"
	dobin "${BUILD_DIR}/bin/WMmp"
}
