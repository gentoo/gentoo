# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop flag-o-matic optfeature toolchain-funcs xdg

MY_PV=${PV//./-}
MY_PAK_64="simupak64-123-0.zip"
# Required for network games, published in release announcement.
MY_SVN_REVISION="10421"

DESCRIPTION="A free Transport Tycoon clone"
HOMEPAGE="https://www.simutrans.com/"
SRC_URI="
	mirror://sourceforge/simutrans/simutrans-src-${MY_PV}.zip
	!minimal? ( mirror://sourceforge/simutrans/${MY_PAK_64} -> simutrans_${MY_PAK_64} )
	https://tastytea.de/files/simutrans_language_pack-Base+texts-${PV}.zip
	https://github.com/aburch/simutrans/raw/9c84822/simutrans.svg
"
S=${WORKDIR}

# NOTE: Get the latest language pack from:
# https://simutrans-germany.com/translator/data/tab/language_pack-Base+texts.zip

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="minimal truetype upnp zstd"

DEPEND="
	app-arch/bzip2
	media-libs/libpng:0
	media-libs/libsdl2[sound,video]
	media-sound/fluidsynth[sdl]
	sys-libs/zlib
	truetype? ( media-libs/freetype )
	upnp? ( net-libs/miniupnpc:= )
	zstd? ( app-arch/zstd )
"
RDEPEND="
	${DEPEND}
	media-sound/fluid-soundfont
"
BDEPEND="
	app-arch/unzip
	virtual/pkgconfig
"
RESTRICT="test" # Opens the program and doesn't close it.

PATCHES=( "${FILESDIR}"/${PN}-123.0.1-silence-svn-and-git-errors.patch )

src_unpack() {
	unpack "simutrans-src-${MY_PV}.zip"
	use minimal || unpack "simutrans_${MY_PAK_64}"

	# Bundled text files are incomplete, bug #580948
	cd "${S}/simutrans/text" || die
	unpack "simutrans_language_pack-Base+texts-${PV}.zip"
}

src_prepare() {
	default
	xdg_environment_reset

	strip-flags # bug #293927
	append-flags -fno-strict-aliasing # bug #859229

	eautoreconf

	# Make it look for the data in the right directory.
	sed -i -e "s:argv\[0\]:\"/usr/share/${PN}/\":" simmain.cc || die
}

src_configure() {
	default

	cat > config.default <<-EOF || die
		BACKEND=sdl2
		OSTYPE=linux
		OPTIMISE=0
		STATIC=0
		MULTI_THREAD=1
		USE_UPNP=$(usex upnp 1 0)
		USE_FREETYPE=$(usex truetype 1 0)
		USE_ZSTD=$(usex zstd 1 0)
		USE_FLUIDSYNTH_MIDI=1
		VERBOSE=1
		FLAGS := -DREVISION="${MY_SVN_REVISION}"

		HOSTCC = $(tc-getCC)
		HOSTCXX = $(tc-getCXX)
	EOF
}

src_install() {
	newbin build/default/sim ${PN}
	insinto usr/share/${PN}
	doins -r simutrans/*
	doicon "${DISTDIR}"/${PN}.svg
	domenu "${FILESDIR}"/${PN}.desktop
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature_header "Since 123.0 this ebuild only installs the Pak64 PakSet. You can install"
	optfeature "other PakSets" games-simulation/simutrans-paksets
}
