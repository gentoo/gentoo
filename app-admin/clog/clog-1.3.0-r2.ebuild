# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Colorized log tail utility"
HOMEPAGE="https://gothenburgbitfactory.org/clog/"
SRC_URI="https://github.com/GothenburgBitFactory/clog/releases/download/v${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x64-macos"
RESTRICT="test" # No test suite on tar.gz

PATCHES=(
	"${FILESDIR}"/${P}-cmake-version.patch # bug 953761
	"${FILESDIR}"/${P}-libshared-cmake-version.patch # bug 953761
	"${FILESDIR}"/${P}-doc-path.patch # bug 677188
	"${FILESDIR}"/${P}-gcc13.patch
	"${FILESDIR}"/${P}-musl.patch
)
