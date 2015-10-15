# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM=git-r3
	EGIT_REPO_URI="https://github.com/01org/libyami"
fi

inherit ${SCM} autotools multilib-minimal

DESCRIPTION="Yet Another Media Infrastructure: Media codec with hardware acceleration"
HOMEPAGE="https://github.com/01org/libyami"

if [ "${PV#9999}" != "${PV}" ] ; then
	KEYWORDS=""
	SRC_URI=""
else
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/01org/libyami/archive/${P}.tar.gz"
	S="${WORKDIR}/${PN}-${P}"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="+capi debug dmabuf doc ffmpeg gles +glx libav md5 tools v4l X"

RDEPEND="
	>=x11-libs/libva-1.6[drm,X?,${MULTILIB_USEDEP}]
	v4l? (
		glx? (
			>=x11-libs/libva-1.6[X,${MULTILIB_USEDEP}]
			>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
			>=virtual/opengl-7[${MULTILIB_USEDEP}]
		)
		!glx? ( >=media-libs/mesa-10[egl,${MULTILIB_USEDEP}] )
		>=media-libs/libv4l-1.6.2[${MULTILIB_USEDEP}]
	)
	X? ( >=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}] )
	ffmpeg? (
		!libav? ( media-video/ffmpeg:0=[${MULTILIB_USEDEP}] )
		libav? ( media-video/libav:=[${MULTILIB_USEDEP}] )
	)
	md5? ( dev-libs/openssl:0=[${MULTILIB_USEDEP}] )
	dmabuf? ( x11-libs/libdrm[${MULTILIB_USEDEP}] )
	tools? (
		gles? ( >=media-libs/mesa-10[egl,gles2,${MULTILIB_USEDEP}] )
		v4l? ( !glx? ( >=media-libs/mesa-10[egl,gles2,${MULTILIB_USEDEP}] ) )
	)
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

src_prepare() {
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable debug) \
		$(multilib_native_use_enable tools tests) \
		$(use gles && multilib_native_use_enable tools tests-gles) \
		$(use_enable v4l v4l2) \
		$(usex v4l $(use_enable glx v4l2-glx) "--disable-v4l2-glx") \
		$(use_enable capi) \
		$(use_enable X x11) \
		$(use_enable dmabuf) \
		$(use_enable ffmpeg avformat) \
		$(use_enable md5) \
		$(multilib_native_use_enable doc docs) \
		--enable-vp8dec \
		--enable-vp9dec \
		--enable-jpegdec \
		--enable-h264dec \
		--disable-h265dec \
		--enable-h264enc \
		--enable-jpegenc \
		--enable-vp8enc \
		--enable-h265enc

	# h265 decoder doesnt build here with gcc 5.2
}

multilib_src_compile() {
	emake
	multilib_is_native_abi && use doc && emake -C doc
}

multilib_src_install() {
	emake DESTDIR="${D}" install
	multilib_is_native_abi && use doc && dohtml -r doc/html/*
}

src_install() {
	multilib-minimal_src_install
	find "${ED}" -name '*.la' -delete
}
