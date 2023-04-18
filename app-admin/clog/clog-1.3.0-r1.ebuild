# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="clog is a colorized log tail utility"
HOMEPAGE="https://taskwarrior.org/docs/clog/"
SRC_URI="https://gothenburgbitfactory.org/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x64-macos"
RESTRICT="test" # No test suite on tar.gz

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.0-gcc13.patch
)

src_prepare() {
	sed -i -e 's|share/doc/clog|share/clog|' CMakeLists.txt || die
	cmake_src_prepare
}
