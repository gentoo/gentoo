# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit autotools eutils games

MY_P=AlephOne-${PV}
DESCRIPTION="An enhanced version of the game engine from the classic Mac game, Marathon"
HOMEPAGE="http://source.bungie.org/"
SRC_URI="mirror://sourceforge/marathon/${MY_P}.tar.bz2"

LICENSE="GPL-2 BitstreamVera"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="alsa mad mpeg sndfile speex truetype vorbis"

RDEPEND="media-libs/sdl-net
	media-libs/sdl-image
	media-libs/libsdl[video]
	dev-libs/expat
	dev-libs/zziplib
	media-libs/libpng:0
	alsa? ( media-libs/alsa-lib )
	mad? ( media-libs/libmad )
	mpeg? ( media-libs/smpeg )
	virtual/opengl
	virtual/glu
	sndfile? ( media-libs/libsndfile )
	speex? ( media-libs/speex )
	truetype? ( media-libs/sdl-ttf )
	vorbis? ( media-libs/libvorbis )"
DEPEND="${RDEPEND}
	dev-libs/boost"

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed "s:GAMES_DATADIR:${GAMES_DATADIR}:g" \
		"${FILESDIR}"/${PN}.sh > "${T}"/${PN}.sh \
		|| die

	# try using the system expat - bug #251108
	sed -i \
		-e '/SUBDIRS/ s/Expat//' \
		-e 's/Expat\/libexpat.a/-lexpat/' \
		Source_Files/Makefile.am \
		|| die
	sed -i \
		-e '/Expat/d' \
		configure.ac \
		|| die
	rm -rf Source_Files/Expat

	# for automake 1.12 compability - bug #422557
	sed -i -e 's:AC_PROG_CC:&\nAC_PROG_OBJCXX:' configure.ac || die

	epatch \
		"${FILESDIR}"/${P}-boost_145.patch \
		"${FILESDIR}"/${P}-gcc47.patch \
		"${FILESDIR}"/${P}-png15.patch

	eautoreconf
}

src_configure() {
	egamesconf \
		--enable-lua \
		$(use_enable alsa) \
		$(use_enable mad) \
		$(use_enable mpeg smpeg) \
		--enable-opengl \
		$(use_enable sndfile) \
		$(use_enable speex) \
		$(use_enable truetype ttf) \
		$(use_enable vorbis)
}

src_install() {
	default
	dogamesbin "${T}"/${PN}.sh
	doman docs/${PN}.6
	dohtml docs/*.html
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	echo
	elog "Read the docs and install the data files accordingly to play."
	echo
	elog "If you only want to install one scenario, read"
	elog "http://traxus.bungie.org/index.php/Aleph_One_install_guide#Single_scenario_3"
	elog "If you want to install multiple scenarios, read"
	elog "http://traxus.bungie.org/index.php/Aleph_One_install_guide#Multiple_scenarios_3"
	echo
}
