# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2-utils

MY_PV="${PV/_rc/-RC}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="OpenTTD is a clone of Transport Tycoon Deluxe"
HOMEPAGE="http://www.openttd.org/"
SRC_URI="http://binaries.openttd.org/releases/${MY_PV}/${MY_P}-source.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="aplaymidi debug dedicated iconv icu lzo +openmedia +png cpu_flags_x86_sse +timidity +truetype zlib"
RESTRICT="test" # needs a graphics set in order to test

RDEPEND="!dedicated? (
		media-libs/libsdl[sound,X,video]
		icu? (
			dev-libs/icu-layoutex
			dev-libs/icu-le-hb
			>=dev-libs/icu-58.1:=
		)
		truetype? (
			media-libs/fontconfig
			media-libs/freetype:2
			sys-libs/zlib
		)
	)
	lzo? ( dev-libs/lzo:2 )
	iconv? ( virtual/libiconv )
	png? ( media-libs/libpng:0 )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
PDEPEND="
	!dedicated? (
		openmedia? (
			games-misc/openmsx
			games-misc/opensfx
		)
		aplaymidi? ( media-sound/alsa-utils )
		!aplaymidi? ( timidity? ( media-sound/timidity++ ) )
	)
	openmedia? ( >=games-misc/opengfx-0.4.7 )"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.6.0-cflags.patch
	"${FILESDIR}"/${PN}-1.8.0-icu61.patch
	"${FILESDIR}"/${PN}-1.8.0-icu62.patch
)

src_configure() {
	local myopts=(
		$(use_with iconv)
		$(use_with png)
		$(use_with cpu_flags_x86_sse sse)
		$(use_with lzo liblzo2)
	)
	# there is an allegro interface available as well as sdl, but
	# the configure for it looks broken so the sdl interface is
	# always built instead.
	myopts+=( --without-allegro )

	# libtimidity not needed except for some embedded platform
	# nevertheless, it will be automagically linked if it is
	# installed. Hence, we disable it.
	myopts+=( --without-libtimidity )

	use debug && myopts+=( --enable-debug=3 )

	if use dedicated ; then
		myopts+=( --enable-dedicated )
	else
		myopts+=(
			$(usex aplaymidi '--with-midi=/usr/bin/aplaymidi' '')
			$(use_with truetype freetype)
			$(use_with icu)
			--with-sdl
		)
	fi
	if use png || { use !dedicated && use truetype; } || use zlib ; then
		myopts+=( --with-zlib )
	else
		myopts+=( --without-zlib )
	fi

	# configure is a hand-written bash-script, so econf will not work.
	# It's all built as C++, upstream uses CFLAGS internally.
	CFLAGS="" ./configure \
		--disable-strip \
		--prefix-dir="${EPREFIX%/}/usr" \
		--binary-dir="bin" \
		--install-dir="${D}" \
		--menu-group="Game;Simulation;" \
		${myopts[@]} \
		|| die
}

src_compile() {
	emake VERBOSE=1
}

src_install() {
	default
	if use dedicated ; then
		newinitd "${FILESDIR}"/${PN}.initd-r1 ${PN}
		rm -rf "${ED%/}"/usr/share/{applications,icons,pixmaps}
	fi
	rm -f "${ED%/}"/usr/share/doc/${PF}/COPYING
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update

	if ! use lzo ; then
		elog "OpenTTD was built without 'lzo' in USE. While 'lzo' is not"
		elog "required, disabling it does mean that loading old savegames"
		elog "or scenarios from ancient versions (~0.2) will fail."
		elog
	fi

	if use dedicated ; then
		ewarn "Warning: The init script will kill all running openttd"
		ewarn "processes when triggered, including any running client sessions!"
	else
		if use aplaymidi ; then
			elog "You have emerged with 'aplaymidi' for playing MIDI."
			elog "This option is for those with a hardware midi device,"
			elog "or who have set up ALSA to handle midi ports."
			elog "You must set the environment variable ALSA_OUTPUT_PORTS."
			elog "Available ports can be listed by using 'aplaymidi -l'."
		else
			if ! use timidity ; then
				elog "OpenTTD was built with neither 'aplaymidi' nor 'timidity'"
				elog "in USE. Music may or may not work in-game. If you happen"
				elog "to have timidity++ installed, music will work so long"
				elog "as it remains installed, but OpenTTD will not depend on it."
			fi
		fi
		if ! use openmedia ; then
			elog
			elog "OpenTTD was compiled without the 'openmedia' USE flag."
			elog
			elog "In order to play, you must at least install:"
			elog "games-misc/opengfx, and games-misc/opensfx, or copy the "
			elog "following 6 files from a version of Transport Tycoon Deluxe"
			elog "(windows or DOS) to ~/.openttd/data/ or"
			elog "${GAMES_DATADIR}/${PN}/data/."
			elog
			elog "From the WINDOWS version you need: "
			elog "sample.cat trg1r.grf trgcr.grf trghr.grf trgir.grf trgtr.grf"
			elog "OR from the DOS version you need: "
			elog "SAMPLE.CAT TRG1.GRF TRGC.GRF TRGH.GRF TRGI.GRF TRGT.GRF"
			elog
			elog "File names are case sensitive, but should work either with"
			elog "all upper or all lower case names"
			elog
			elog "In addition, in-game music will be unavailable: for music,"
			elog "install games-misc/openmsx, or use the in-game download"
			elog "functionality to get a music set"
			elog
		fi
	fi
}

pkg_postrm() {
	gnome2_icon_cache_update
}
