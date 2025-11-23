# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="ncurses PulseAudio Mixer"
HOMEPAGE="https://github.com/fulhax/ncpamixer"
SRC_URI="https://github.com/fulhax/ncpamixer/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+man +unicode"

DEPEND="
	media-libs/libpulse:=
	sys-libs/ncurses:=[unicode(+)?]
"
RDEPEND="${DEPEND}"
BDEPEND="
	man? ( app-text/lowdown )
"

CMAKE_USE_DIR="${S}/src"

src_configure() {
	local mycmakeargs=(
		-DUSE_WIDE=$(usex unicode)
		-DBUILD_MANPAGES=no
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	use man && lowdown -s -tman src/man/ncpamixer.1.md -o ncpamixer.1
}

src_install() {
	cmake_src_install

	use man && doman ncpamixer.1
	dodoc "${S}"/README.md
}
