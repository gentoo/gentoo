# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="JThread provides some classes to make use of threads easy on different platforms"
HOMEPAGE="https://research.edm.uhasselt.be/jori/page/CS/Jthread.html"
SRC_URI="https://research.edm.uhasselt.be/jori/${PN}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 x86"

DOCS=( ChangeLog README.md doc/manual.tex )

src_prepare() {
	# Do not build static library
	sed -i -e '/jthread-static/d' src/CMakeLists.txt || die 'sed on src/CMakeLists.txt failed'

	cmake_src_prepare
}
