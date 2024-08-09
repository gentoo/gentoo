# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop flag-o-matic toolchain-funcs xdg

MY_PV=${PV//./-}
MY_PAK_64="simupak64-124-2.zip" # NOTE: usually this is ${MY_PV}
# Required for network games, published in release announcement on the forums
# <https://forum.simutrans.com/index.php/board,3.0.html>
MY_SVN_REVISION="11366"

DESCRIPTION="A free Transport Tycoon clone"
HOMEPAGE="https://www.simutrans.com/"
SRC_URI="
	https://downloads.sourceforge.net/simutrans/simutrans-src-${MY_PV}.zip
	!minimal? ( https://downloads.sourceforge.net/simutrans/${MY_PAK_64} -> simutrans_${MY_PAK_64} )
	https://tastytea.de/files/gentoo/simutrans_language_pack-Base+texts-${PV}.zip
"
S="${WORKDIR}/trunk"

# NOTE: get the latest language pack from:
# https://simutrans-germany.com/translator/data/tab/language_pack-Base+texts.zip

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="minimal +midi fontconfig upnp zstd"

DEPEND="
	app-arch/bzip2
	media-libs/freetype
	media-libs/libpng:0=
	media-libs/libsdl2[sound,video]
	sys-libs/zlib
	midi? ( media-sound/fluidsynth:=[sdl] )
	fontconfig? ( media-libs/fontconfig )
	upnp? ( net-libs/miniupnpc:= )
	zstd? ( app-arch/zstd )
"
RDEPEND="
	${DEPEND}
	midi? ( media-sound/fluid-soundfont )
	!<games-simulation/simutrans-paksets-${PV}
"
BDEPEND="
	app-arch/unzip
	virtual/pkgconfig
"
RESTRICT="test" # Opens the program and doesn't close it.

PATCHES=(
	"${FILESDIR}"/${PN}-124.0-disable-svn-check.patch
)

src_unpack() {
	unpack "simutrans-src-${MY_PV}.zip"
	cd trunk/simutrans || die "could not cd to ‘simutrans’"
	use minimal || unpack "simutrans_${MY_PAK_64}"

	# Bundled text files are incomplete, bug #580948
	cd text || die "could not cd to ‘simutrans/text’"
	unpack "simutrans_language_pack-Base+texts-${PV}.zip"
}

src_prepare() {
	default
	xdg_environment_reset

	strip-flags # bug #293927
	append-flags -fno-strict-aliasing # bug #859229

	eautoreconf
}

src_configure() {
	default

	# NOTE: some flags need to be 0, some need to be empty to turn them off
	cat > config.default <<-EOF || die
		BACKEND=sdl2
		OSTYPE=linux
		OPTIMISE=0
		STATIC=0
		WITH_REVISION=${MY_SVN_REVISION}
		MULTI_THREAD=1
		USE_UPNP=$(usex upnp 1 '')
		USE_FREETYPE=1
		USE_ZSTD=$(usex zstd 1 '')
		USE_FONTCONFIG=$(usex fontconfig 1 '')
		USE_FLUIDSYNTH_MIDI=$(usex midi 1 '')
		VERBOSE=1

		HOSTCC = $(tc-getCC)
		HOSTCXX = $(tc-getCXX)
	EOF
}

src_install() {
	newbin build/default/sim ${PN}
	insinto usr/share/${PN}
	doins -r simutrans/*
	doicon src/simutrans/${PN}.svg
	domenu src/linux/simutrans.desktop
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "Since 124.0 simutrans allows you to download PakSets to your home directory,"
	elog "therefore games-simulation/simutrans-paksets has been deprecated."
}
