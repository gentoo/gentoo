# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop flag-o-matic xdg

MY_PV=${PV/0./}
MY_PV=${MY_PV//./-}
SIMUPAK_64="simupak64-${MY_PV%-[0-9]*}-0.zip"
SIMUPAK_128_V="2.8.1"
SIMUPAK_128_BRITAIN="pak128.Britain.1.18-120-3.zip"
SIMUPAK_128_GERMAN="PAK128.german_2.0_for_ST_122.0.zip"
SIMUPAK_192_COMIC="pak192.comic.0.5.zip"

DESCRIPTION="A free Transport Tycoon clone"
HOMEPAGE="https://www.simutrans.com/"
SRC_URI="mirror://sourceforge/simutrans/simutrans-src-${MY_PV}.zip
	https://simutrans-germany.com/translator/data/tab/language_pack-Base+texts.zip -> simutrans_language_pack-Base+texts-${PV}.zip
	mirror://sourceforge/simutrans/${SIMUPAK_64} -> simutrans_${SIMUPAK_64}
	pak128? ( https://download.sourceforge.net/simutrans/pak128/pak128%20for%20ST%20120.4.1%20%28${SIMUPAK_128_V}%2C%20priority%20signals%20%2B%20bugfix%29/pak128.zip -> simutrans_pak128-${SIMUPAK_128_V}.zip )
	pak128-britain? ( mirror://sourceforge/simutrans/${SIMUPAK_128_BRITAIN} -> simutrans_${SIMUPAK_128_BRITAIN} )
	pak128-german? ( mirror://sourceforge/simutrans/${SIMUPAK_128_GERMAN} -> simutrans_${SIMUPAK_128_GERMAN} )
	pak192-comic? (
		mirror://sourceforge/simutrans/${SIMUPAK_192_COMIC} -> simutrans_${SIMUPAK_192_COMIC}
		https://www.dropbox.com/s/3wwyrajrr2oqzo6/coalwagons.rar?dl=1 -> simutrans_coalwagonfix.rar
	)"
S=${WORKDIR}

LICENSE="Artistic"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="+pak128 +pak128-britain +pak128-german +pak192-comic truetype upnp zstd"

RDEPEND="
	app-arch/bzip2
	app-arch/zstd
	media-libs/libpng:0
	media-libs/libsdl2[sound,video]
	media-libs/sdl-mixer[midi]
	sys-libs/zlib
	truetype? ( media-libs/freetype )
	upnp? ( net-libs/miniupnpc:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/unrar
	app-arch/unzip
	virtual/imagemagick-tools[png]
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}/simutrans-0.122.0-Fix-Makefile.patch" )

src_unpack() {
	unpack "simutrans-src-${MY_PV}.zip"
	unpack "simutrans_${SIMUPAK_64}"
	use pak128 && unpack "simutrans_pak128-${SIMUPAK_128_V}.zip"
	use pak128-britain && unpack "simutrans_${SIMUPAK_128_BRITAIN}"
	use pak128-german && unpack "simutrans_${SIMUPAK_128_GERMAN}"
	if use pak192-comic; then
		unpack "simutrans_${SIMUPAK_192_COMIC}"
		cd simutrans/pak192.comic || die
		unpack "simutrans_coalwagonfix.rar" # Fixes invisible wagons.
	fi

	# Bundled text files are incomplete, bug #580948
	cd "${S}/simutrans/text" || die
	unpack "simutrans_language_pack-Base+texts-${PV}.zip"
}

src_prepare() {
	default
	xdg_environment_reset

	strip-flags # bug #293927

	cat > config.default <<-EOF || die
		BACKEND=mixer_sdl
		OSTYPE=linux
		MULTI_THREAD=1
		USE_UPNP=$(usex upnp 1 0)
		USE_FREETYPE=$(usex truetype 1 0)
		USE_ZSTD=$(usex zstd 1 0)
		VERBOSE=1
		STATIC=0
	EOF

	# make it look in the install location for the data
	sed -i -e "s:argv\[0\]:\"/usr/share/${PN}/\":" simmain.cc || die
}

src_compile() {
	default

	# Convert icon to PNG for Desktop Entry.
	convert simutrans.ico simutrans.png || die
}

src_install() {
	newbin build/default/sim ${PN}
	insinto /usr/share/${PN}
	doins -r simutrans/*
	doicon simutrans.png
	domenu "${FILESDIR}/${PN}.desktop"
}
