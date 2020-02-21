# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools eutils ltprune multilib flag-o-matic

DESCRIPTION="The most advanced non-linear video editor and compositor"
HOMEPAGE="http://www.cinelerra.org/"
SRC_URI="https://cinelerra-cv.org/releases/CinelerraCV-${PV}.tar.xz
	https://dev.gentoo.org/~mgorny/dist/${P}-patchset.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="cpu_flags_x86_3dnow alsa altivec css debug ieee1394 cpu_flags_x86_mmx opengl oss"

RDEPEND="media-libs/a52dec:=
	media-libs/faac:=
	media-libs/faad2:=
	>=media-libs/freetype-2
	media-libs/fontconfig
	media-libs/libdv:=
	>=media-libs/libogg-1.2:=
	media-libs/libpng:0=
	media-libs/libsndfile:=
	>=media-libs/libtheora-1.1:=
	>=media-libs/libvorbis-1.3:=
	>=media-libs/openexr-1.5:=
	media-libs/tiff:0=
	media-libs/x264:=
	media-sound/lame:=
	>=media-video/mjpegtools-2
	>=sci-libs/fftw-3
	x11-libs/libX11:=
	x11-libs/libXext:=
	x11-libs/libXft:=
	x11-libs/libXv:=
	x11-libs/libXvMC:=
	x11-libs/libXxf86vm:=
	virtual/ffmpeg
	|| ( media-video/ffmpeg:0[postproc(-)] media-libs/libpostproc )
	virtual/jpeg:0
	alsa? ( media-libs/alsa-lib:= )
	ieee1394? (
		media-libs/libiec61883:=
		>=sys-libs/libraw1394-1.2.0:=
		>=sys-libs/libavc1394-0.5.0:=
		)
	opengl? (
		virtual/glu
		virtual/opengl
		)"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig
	cpu_flags_x86_mmx? ( dev-lang/nasm )"

S="${WORKDIR}/CinelerraCV-${PV}"

src_prepare() {
	epatch \
		"${WORKDIR}"/${P}-patchset/${PN}-20140710-validate_desktop_entry.patch \
		"${WORKDIR}"/${P}-patchset/${PN}-ffmpeg.patch \
		"${WORKDIR}"/${P}-patchset/${PN}-20140710-underlinking.patch \
		"${WORKDIR}"/${P}-patchset/${PN}-20140710-ffmpeg-0.11.patch \
		"${WORKDIR}"/${P}-patchset/${PN}-libav9.patch \
		"${WORKDIR}"/${P}-patchset/${PN}-pngtoh.patch \
		"${WORKDIR}"/${P}-patchset/${PN}-putbits-gcc52.patch \
		"${WORKDIR}"/${P}-patchset/${PN}-implicit_decls.patch \
		"${WORKDIR}"/${P}-patchset/${PN}-includes.patch

	if has_version '>=media-video/ffmpeg-2' ; then
		epatch "${WORKDIR}"/${P}-patchset/${PN}-ffmpeg2.patch
	fi

	if has_version '>=media-video/ffmpeg-2.9' ; then
		epatch "${WORKDIR}"/${P}-patchset/${PN}-ffmpeg29.patch
	fi

	if has_version '>=media-video/ffmpeg-3.5' ; then
		epatch "${FILESDIR}/ffmpeg4.patch"
	fi

	eautoreconf
}

src_configure() {
	append-cppflags -D__STDC_CONSTANT_MACROS #321945
	append-ldflags -Wl,-z,noexecstack #212959

	local myconf
	use debug && myconf='--enable-x-error-output'

	econf \
		$(use_enable oss) \
		$(use_enable alsa) \
		--disable-esd \
		$(use_enable ieee1394 firewire) \
		$(use_enable css) \
		$(use_enable cpu_flags_x86_mmx mmx) \
		$(use_enable cpu_flags_x86_3dnow 3dnow) \
		$(use_enable altivec) \
		$(use_enable opengl) \
		--with-plugindir=/usr/$(get_libdir)/${PN} \
		--with-buildinfo=cust/"Gentoo - ${PV}" \
		--with-external-ffmpeg \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install
	dohtml -a png,html,texi,sdw -r doc/*

	rm -rf "${D}"/usr/include
	mv -vf "${D}"/usr/bin/mpeg3cat{,.hv} || die
	mv -vf "${D}"/usr/bin/mpeg3dump{,.hv} || die
	mv -vf "${D}"/usr/bin/mpeg3toc{,.hv} || die
	dosym /usr/bin/mpeg2enc /usr/$(get_libdir)/${PN}/mpeg2enc.plugin

	prune_libtool_files --all
}
