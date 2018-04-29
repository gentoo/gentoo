# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils

MY_P=AlephOne-${PV}
DESCRIPTION="An enhanced version of the game engine from the classic Mac game, Marathon"
HOMEPAGE="http://source.bungie.org/"
SRC_URI="https://github.com/Aleph-One-Marathon/alephone/releases/download/release-${PV}/AlephOne-${PV}.tar.bz2"

LICENSE="GPL-3+ BitstreamVera OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="alsa curl ffmpeg mad mpeg sndfile speex vorbis"

RDEPEND="
	dev-libs/boost
	dev-libs/expat
	dev-libs/zziplib
	media-libs/libpng:0
	media-libs/libsdl[joystick,opengl,video]
	media-libs/sdl-image[png]
	media-libs/sdl-net
	media-libs/sdl-ttf
	virtual/opengl
	virtual/glu
	alsa? ( media-libs/alsa-lib )
	curl? ( net-misc/curl )
	ffmpeg? ( virtual/ffmpeg )
	mad? ( media-libs/libmad )
	mpeg? ( media-libs/smpeg )
	sndfile? ( media-libs/libsndfile )
	speex? ( media-libs/speex )
	vorbis? ( media-libs/libvorbis )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

src_prepare() {
	default

	sed "s:GAMES_DATADIR:/usr/share:g" \
		"${FILESDIR}"/${PN}.sh > "${T}"/${PN}.sh \
		|| die

	# try using the system expat - bug #251108
	sed -i \
		-e '/SUBDIRS/ s/Expat//' \
		-e 's/Expat\/libexpat.a/-lexpat/' \
		Source_Files/Makefile.am || die
	sed -i -e '/Expat/d' configure.ac || die
	rm -r Source_Files/Expat || die

	eautoreconf
}

src_configure() {
	econf \
		--enable-lua \
		--enable-opengl \
		$(use_with alsa) \
		$(use_with ffmpeg) \
		$(use_with mad) \
		$(use_with mpeg smpeg) \
		$(use_with sndfile) \
		$(use_with speex) \
		$(use_with vorbis)
}

src_install() {
	default
	dobin "${T}"/${PN}.sh
	doman docs/${PN}.6
	dodoc docs/*.html
}

pkg_postinst() {
	echo
	elog "Read the docs and install the data files accordingly to play."
	echo
	elog "If you only want to install one scenario, read"
	elog "http://traxus.bungie.org/index.php/Aleph_One_install_guide#Single_scenario_3"
	elog "If you want to install multiple scenarios, read"
	elog "http://traxus.bungie.org/index.php/Aleph_One_install_guide#Multiple_scenarios_3"
	echo
}
