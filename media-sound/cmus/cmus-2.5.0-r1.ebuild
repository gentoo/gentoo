# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils multilib

MY_P=${PN}-v${PV}

DESCRIPTION="A ncurses based music player with plugin support for many formats"
HOMEPAGE="http://cmus.sourceforge.net/"
SRC_URI="mirror://sourceforge/cmus/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="aac alsa ao cue cdio cddb discid debug examples flac +mad mikmod modplug mp4 musepack oss pidgin pulseaudio unicode vorbis wavpack wma zsh-completion"

CDEPEND="sys-libs/ncurses[unicode?]
	aac? ( media-libs/faad2 )
	alsa? ( >=media-libs/alsa-lib-1.0.11 )
	ao? ( media-libs/libao )
	cue? ( media-libs/libcue )
	cdio? ( dev-libs/libcdio-paranoia )
	cddb? ( media-libs/libcddb )
	discid? ( media-libs/libdiscid )
	flac? ( media-libs/flac )
	mad? ( >=media-libs/libmad-0.14 )
	mikmod? ( media-libs/libmikmod:0 )
	modplug? ( >=media-libs/libmodplug-0.7 )
	mp4? ( >=media-libs/libmp4v2-1.9:0 )
	musepack? ( >=media-sound/musepack-tools-444 )
	pulseaudio? ( media-sound/pulseaudio )
	vorbis? ( >=media-libs/libvorbis-1.0 )
	wavpack? ( media-sound/wavpack )
	wma? ( >=virtual/ffmpeg-0.10.2-r1 )"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	zsh-completion? ( app-shells/zsh )
	pidgin? ( net-im/pidgin
		dev-python/dbus-python )"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-cdio-make-it-work-with-libcdio-0.90.patch #452446
}

my_config() {
	local value
	use ${1} && value=a || value=n
	myconf="${myconf} ${2}=${value}"
}

src_configure() {
	local debuglevel=1 myconf="CONFIG_ARTS=n CONFIG_SUN=n"

	use debug && debuglevel=2

	my_config cue CONFIG_CUE
	my_config cddb CONFIG_CDDB
	my_config cdio CONFIG_CDIO
	my_config discid CONFIG_DISCID
	my_config flac CONFIG_FLAC
	my_config mad CONFIG_MAD
	my_config modplug CONFIG_MODPLUG
	my_config mikmod CONFIG_MIKMOD
	my_config musepack CONFIG_MPC
	my_config vorbis CONFIG_VORBIS
	my_config wavpack CONFIG_WAVPACK
	my_config mp4 CONFIG_MP4
	my_config aac CONFIG_AAC
	my_config wma CONFIG_FFMPEG
	my_config pulseaudio CONFIG_PULSE
	my_config alsa CONFIG_ALSA
	my_config ao CONFIG_AO
	my_config oss CONFIG_OSS

	./configure prefix="${EPREFIX}"/usr ${myconf} exampledir="${EPREFIX}"/usr/share/doc/${PF}/examples \
		libdir="${EPREFIX}"/usr/$(get_libdir) DEBUG=${debuglevel} || die
}

src_install() {
	default

	use examples || rm -rf "${ED}"/usr/share/doc/${PF}/examples

	if use zsh-completion; then
		insinto /usr/share/zsh/site-functions
		doins contrib/_cmus
	fi

	if use pidgin; then
		newbin contrib/cmus-updatepidgin.py cmus-updatepidgin
	fi
}
