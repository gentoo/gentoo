# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit libtool eutils

DESCRIPTION="An enchanced version of the quicktime4linux library"
HOMEPAGE="http://libquicktime.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="aac alsa doc dv encode ffmpeg gtk jpeg lame cpu_flags_x86_mmx opengl png schroedinger static-libs vorbis X x264"

RDEPEND="virtual/libintl
	aac? (
		media-libs/faad2
		encode? ( media-libs/faac )
		)
	alsa? ( >=media-libs/alsa-lib-1.0.20 )
	dv? ( media-libs/libdv )
	ffmpeg? ( virtual/ffmpeg )
	gtk? ( x11-libs/gtk+:2 )
	jpeg? ( virtual/jpeg )
	lame? ( media-sound/lame )
	opengl? ( virtual/opengl )
	png? ( media-libs/libpng:0 )
	schroedinger? ( >=media-libs/schroedinger-1.0.10 )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
		)
	X? (
		x11-libs/libX11
		x11-libs/libXaw
		x11-libs/libXext
		x11-libs/libXt
		x11-libs/libXv
		)
	x264? ( media-libs/x264 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext
	doc? ( app-doc/doxygen )
	X? ( x11-proto/videoproto )"

REQUIRED_USE="opengl? ( X )"

DOCS="ChangeLog README TODO"

src_prepare() {
	epatch "${FILESDIR}"/${P}+libav-9.patch \
		"${FILESDIR}"/${P}-ffmpeg2.patch
	elibtoolize # Required for .so versioning on g/fbsd
}

src_configure() {
	econf \
		--enable-gpl \
		$(use_enable static-libs static) \
		$(use_enable cpu_flags_x86_mmx asm) \
		$(use_with doc doxygen) \
		$(use vorbis || echo --without-vorbis) \
		$(use_with lame) \
		$(use_with X x) \
		$(use_with opengl) \
		$(use_with alsa) \
		$(use_with gtk) \
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
}

src_install() {
	default
	find "${ED}" -name '*.la' -exec rm -f {} +

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
