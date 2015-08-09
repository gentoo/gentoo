# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic multilib-minimal

MY_PN="gst-ffmpeg"
MY_P=${MY_PN}-${PV}

# Create a major/minor combo for SLOT
PVP=(${PV//[-\._]/ })
SLOT=${PVP[0]}.${PVP[1]}

DESCRIPTION="FFmpeg based gstreamer plugin"
HOMEPAGE="http://gstreamer.freedesktop.org/modules/gst-ffmpeg.html"
#SRC_URI="http://gstreamer.freedesktop.org/src/${MY_PN}/${MY_P}.tar.bz2"
SRC_URI="http://dev.gentoo.org/~tetromino/distfiles/${PN}/${MY_P}.tar.xz
	http://dev.gentoo.org/~tetromino/distfiles/${PN}/${MY_P}-libav-9-patches.tar.xz"

LICENSE="GPL-2"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="+orc"

S=${WORKDIR}/${MY_P}

RDEPEND=">=media-libs/gstreamer-0.10.36-r2:0.10[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-0.10.36:0.10[${MULTILIB_USEDEP}]
	>=virtual/ffmpeg-9-r1[${MULTILIB_USEDEP}]
	|| (
		>=media-video/ffmpeg-1.2.6-r1:0[${MULTILIB_USEDEP}]
		>=media-libs/libpostproc-10.20140517-r1[${MULTILIB_USEDEP}]
	)
	orc? ( >=dev-lang/orc-0.4.17[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}
	abi_x86_32? (
		!app-emulation/emul-linux-x86-gstplugins[-abi_x86_32(-)]
	)"

src_prepare() {
	sed -e 's/sleep 15//' -i configure.ac configure || die

	# libav-9 support backported from gst-plugins-libav-1.1.0
	epatch ../${MY_P}-libav-9-patches/*.patch

	# compat bits for older ffmpeg/libav releases
	epatch "${FILESDIR}/${PV}-channel_layout.patch" \
		"${FILESDIR}/${PV}-iscodec.patch" \
		"${FILESDIR}/${PV}-coma.patch" \
		"${FILESDIR}/${PV}-gstffmpegpipe_redef.patch"

	# compatibility with recent releases
	if has_version '>=media-video/ffmpeg-1.1' || has_version '>=media-video/libav-9' ; then
		epatch "${FILESDIR}/${PV}-planaraudio.patch"
		sed -i -e 's/ CODEC_ID/ AV_CODEC_ID/g' \
			   -e 's/ CodecID/ AVCodecID/g' \
			   ext/ffmpeg/*.{c,h}
		epatch "${FILESDIR}/${PV}-ffmpeg2.patch"
	fi
}

multilib_src_configure() {
	# always use system ffmpeg if possible
	ECONF_SOURCE=${S} \
	econf \
		--with-system-ffmpeg \
		$(use_enable orc)
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files --modules
}

pkg_postinst() {
	if has_version "media-video/ffmpeg"; then
		elog "Please note that upstream uses media-video/libav"
		elog "rather than media-video/ffmpeg. If you encounter any"
		elog "issues try to move from ffmpeg to libav."
	fi
}
