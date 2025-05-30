# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

MY_P=${P/soxt/SoXt}

DESCRIPTION="GUI binding for using Coin/Open Inventor with Xt/Motif"
HOMEPAGE="https://github.com/coin3d/coin/wiki"
SRC_URI="https://github.com/coin3d/soxt/releases/download/v${PV}/${P}-src.tar.gz"
S="${WORKDIR}/soxt"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="debug doc"

RDEPEND="
	media-libs/coin
	x11-libs/motif:0
	virtual/opengl
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	x11-base/xorg-proto
	doc? ( app-text/doxygen )
"

DOCS=( AUTHORS ChangeLog HACKING NEWS README TODO BUGS.txt )

src_configure() {
	use debug && append-cppflags -DSOXT_DEBUG=1
	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR="${EPREFIX}/usr/share/doc/${PF}"
		-DSOXT_BUILD_DOCUMENTATION=$(usex doc)
		-DSOXT_BUILD_INTERNAL_DOCUMENTATION=OFF
		# Interactive test programs
		-DSOXT_BUILD_TESTS=OFF
		-DSOXT_VERBOSE=$(usex debug)
	)
	cmake_src_configure
}
