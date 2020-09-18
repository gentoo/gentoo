# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic qmake-utils

DESCRIPTION="Simple C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
HOMEPAGE="https://stachenov.github.io/quazip/"
SRC_URI="https://github.com/stachenov/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5
	sys-libs/zlib[minizip]
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-no-static-lib.patch"
	"${FILESDIR}/${P}-gnuinstalldirs.patch"
)

src_install() {
	cmake_src_install

	# compatibility with not yet fixed rdeps (Gentoo bug #598136)
	dosym libquazip5.so /usr/$(get_libdir)/libquazip.so
}
