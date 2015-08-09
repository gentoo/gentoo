# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic games

DESCRIPTION="GNU/Linux port of the MAME emulator with GUI menu"
HOMEPAGE="http://advancemame.sourceforge.net/"
SRC_URI="mirror://sourceforge/advancemame/${P}.tar.gz"

LICENSE="GPL-2 XMAME"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="alsa fbcon oss truetype"

# sdl is required (bug #158417)
RDEPEND="app-arch/unzip
	app-arch/zip
	dev-libs/expat
	media-libs/libsdl
	sys-libs/zlib
	alsa? ( media-libs/alsa-lib )
	truetype? ( media-libs/freetype )"
DEPEND="${RDEPEND}
	virtual/os-headers
	x86? ( >=dev-lang/nasm-0.98 )"

src_prepare() {
	epatch "${FILESDIR}/${P}-pic.patch" \
		"${FILESDIR}"/${P}-verboselog.patch

	sed -i \
		-e 's/"-s"//' \
		configure || die "sed failed"

	use x86 &&
		ln -s $(type -P nasm) "${T}/${CHOST}-nasm"
	ln -s $(type -P sdl-config) "${T}/${CHOST}-sdl-config"
	use truetype &&
		ln -s $(type -P freetype-config) "${T}/${CHOST}-freetype-config"
}

src_configure() {
	# Fix for bug #78030
	if use ppc; then
		append-ldflags "-Wl,--relax"
	fi

	PATH="${PATH}:${T}"
	egamesconf \
		--enable-expat \
		--enable-sdl \
		--enable-zlib \
		--disable-slang \
		--disable-svgalib \
		--disable-static \
		$(use_enable alsa) \
		$(use_enable fbcon fb) \
		$(use_enable oss) \
		$(use_enable truetype freetype) \
		$(use_enable x86 asm) \
		--with-emu=${PN/advance}
}

src_compile() {
	STRIPPROG=true emake
}

src_install() {
	local f

	for f in adv* ; do
		if [[ -L "${f}" ]] ; then
			dogamesbin "${f}"
		fi
	done

	insinto "${GAMES_DATADIR}/advance"
	doins support/event.dat
	keepdir "${GAMES_DATADIR}/advance/"{artwork,diff,image,rom,sample,snap}

	dodoc HISTORY README RELEASE
	cd doc
	dodoc *.txt
	dohtml *.html
	for f in *.1 ; do
		newman ${f} ${f/1/6}
	done

	prepgamesdirs
}
