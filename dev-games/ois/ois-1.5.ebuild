# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Object-oriented Input System - A cross-platform C++ input handling library"
HOMEPAGE="https://github.com/wgois/OIS"
SRC_URI="https://github.com/wgois/OIS/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P^^}"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

DEPEND="
	x11-libs/libXaw
	x11-libs/libX11
"

PATCHES=(
	"${FILESDIR}/${P}-libdir.patch"
)
