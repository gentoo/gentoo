# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="clog is a colorized log tail utility"
HOMEPAGE="https://taskwarrior.org/docs/clog/"
SRC_URI="https://gothenburgbitfactory.org/download/${P}.tar.gz"

KEYWORDS="~amd64 ~x86 ~x64-macos"
LICENSE="MIT"
SLOT="0"
RESTRICT="test" # No test suite on tar.gz

src_prepare() {
	default
	sed -i -e 's|share/doc/clog|share/clog|' CMakeLists.txt || die
	cmake_src_prepare
}
