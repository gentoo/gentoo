# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Diablo engine for modern operating systems"
HOMEPAGE="https://github.com/diasurgical/devilutionX/"
SRC_URI="https://github.com/diasurgical/devilutionX/releases/download/${PV}/devilutionx-src.tar.xz -> ${P}.tar.xz"
S="${WORKDIR}/${PN}-src-${PV}"

LICENSE="Unlicense CC-BY-4.0 GPL-2+ LGPL-2.1+ MIT OFL-1.1 zerotier? ( BUSL-1.1 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +sodium test zerotier"
RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/bzip2:=
	dev-libs/libfmt:=
	media-libs/libsdl2[haptic,joystick,opengl,video]
	media-libs/sdl2-image[png]
	sys-libs/zlib:=
	media-libs/sdl_audiolib
	sodium? ( dev-libs/libsodium:= )"
DEPEND="
	${RDEPEND}
	dev-cpp/asio
	dev-cpp/simpleini
	test? ( dev-cpp/gtest )"
BDEPEND="sys-devel/gettext"

src_prepare() {
	cmake_src_prepare

	# use system asio
	echo 'add_library(asio INTERFACE)' > 3rdParty/asio/CMakeLists.txt || die

	# ensure system copies are used
	rm -r dist/{asio,simpleini,sdl_audiolib}-src || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DCCACHE_PROGRAM=no #813768
		-DDEBUG=$(usex debug)
		-DDISABLE_LTO=yes # let CFLAGS control this
		-DDISABLE_ZERO_TIER=$(usex !zerotier)
		-DPACKET_ENCRYPTION=$(usex sodium)
		-DPIE=yes
		-DFETCHCONTENT_FULLY_DISCONNECTED=yes
	)

	cmake_src_configure
}

src_test() {
	# timedemo tests only pass when game assets are available
	cmake_src_test -E Timedemo.
}

src_install() {
	local DOCS=( Packaging/nix/README.txt docs/*.md )
	cmake_src_install

	rm "${ED}"/usr/share/diasurgical/devilutionx/README.txt || die
}

pkg_postinst() {
	xdg_pkg_postinst

	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog "In order to play the game, you will need to copy the following data file"
		elog "from the original game, and optionally the hellfire expansion files:"
		elog "	- DIABDAT.MPQ"
		elog "	- hellfire.mpq hfmonk.mpq hfmusic.mpq hfvoice.mpq"
		elog "to ~/.local/share/diasurgical/devilution/"
		elog
		elog "See ${EROOT}/usr/share/doc/${PF}/README.txt* for details."
	fi
}
