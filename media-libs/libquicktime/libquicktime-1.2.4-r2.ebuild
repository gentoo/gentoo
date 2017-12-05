# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit libtool eutils multilib-minimal

DESCRIPTION="An enhanced version of the quicktime4linux library"
HOMEPAGE="http://libquicktime.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 hppa ia64 ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="aac alsa doc dv encode ffmpeg gtk jpeg lame libav cpu_flags_x86_mmx opengl png schroedinger static-libs vorbis X x264"

RDEPEND=">=virtual/libintl-0-r1[${MULTILIB_USEDEP}]
	sys-libs/zlib:=
	aac? (
		>=media-libs/faad2-2.7-r3[${MULTILIB_USEDEP}]
		encode? ( >=media-libs/faac-1.28-r3[${MULTILIB_USEDEP}] )
		)
	alsa? ( >=media-libs/alsa-lib-1.0.20 )
	dv? ( >=media-libs/libdv-1.0.0-r3[${MULTILIB_USEDEP}] )
	ffmpeg? (
		libav? ( media-video/libav:0=[${MULTILIB_USEDEP}] )
		!libav? ( media-video/ffmpeg:0=[${MULTILIB_USEDEP}] )
	)
	gtk? ( x11-libs/gtk+:2 )
	jpeg? ( >=virtual/jpeg-0-r2:0[${MULTILIB_USEDEP}] )
	lame? ( >=media-sound/lame-3.99.5-r1[${MULTILIB_USEDEP}] )
	opengl? ( virtual/opengl )
	png? ( >=media-libs/libpng-1.6.10:0[${MULTILIB_USEDEP}] )
	schroedinger? ( >=media-libs/schroedinger-1.0.11-r1[${MULTILIB_USEDEP}] )
	vorbis? (
		>=media-libs/libogg-1.3.0[${MULTILIB_USEDEP}]
		>=media-libs/libvorbis-1.3.3-r1[${MULTILIB_USEDEP}]
		)
	X? (
		x11-libs/libX11
		x11-libs/libXaw
		x11-libs/libXext
		x11-libs/libXt
		x11-libs/libXv
		)
	x264? ( >=media-libs/x264-0.0.20130506:=[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
	sys-devel/gettext
	doc? ( app-doc/doxygen )
	X? ( >=x11-proto/videoproto-2.3.1-r1[${MULTILIB_USEDEP}] )"

REQUIRED_USE="opengl? ( X )"

DOCS="ChangeLog README TODO"

src_prepare() {
	epatch "${FILESDIR}"/${P}+libav-9.patch \
		"${FILESDIR}"/${P}-ffmpeg2.patch \
		"${FILESDIR}/CVE-2016-2399.patch"
	if has_version '>=media-video/ffmpeg-2.9' ||
		has_version '>=media-video/libav-12'; then
		epatch "${FILESDIR}"/${P}-ffmpeg29.patch
	fi

	for FILE in lqt_ffmpeg.c video.c audio.c ; do
		sed -i -e "s:CODEC_ID_:AV_&:g" "${S}/plugins/ffmpeg/${FILE}" || die
	done

	elibtoolize # Required for .so versioning on g/fbsd
}

multilib_src_configure() {
	# utils use: alsa, opengl, gtk+, X

	ECONF_SOURCE=${S} \
	econf \
		--enable-gpl \
		$(use_enable static-libs static) \
		$(use_enable cpu_flags_x86_mmx asm) \
		$(multilib_native_use_with doc doxygen) \
		$(use vorbis || echo --without-vorbis) \
		$(use_with lame) \
		$(multilib_native_use_with X x) \
		$(multilib_native_use_with opengl) \
		$(multilib_native_use_with alsa) \
		$(multilib_native_use_with gtk) \
		$(use_with dv libdv) \
		$(use_with jpeg libjpeg) \
		$(use_with ffmpeg) \
		$(use_with png libpng) \
		$(use_with schroedinger) \
		$(use_with aac faac) \
		$(use encode || echo --without-faac) \
		$(use_with aac faad2) \
		$(use_with x264) \
		--without-cpuflags

	if ! multilib_is_native_abi; then
		# disable building utilities
		sed -i -e '/SUBDIRS =/s:utils::' Makefile || die
	fi
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files --all

	# Compatibility with software that uses quicktime prefix, but
	# don't do that when building for Darwin/MacOS
	[[ ${CHOST} != *-darwin* ]] && dosym /usr/include/lqt /usr/include/quicktime
}

pkg_preinst() {
	if [[ -d /usr/include/quicktime && ! -L /usr/include/quicktime ]]; then
		elog "For compatibility with other quicktime libraries, ${PN} was"
		elog "going to create a /usr/include/quicktime symlink, but for some"
		elog "reason that is a directory on your system."

		elog "Please check that is empty, and remove it, or submit a bug"
		elog "telling us which package owns the directory."
		die "/usr/include/quicktime is a directory."
	fi
}
