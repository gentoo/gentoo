# Copyright 1999-2016 Gentoo Foundation
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

LICENSE="Apache-2.0"
SLOT="0"
IUSE="+capi debug dmabuf doc md5 v4l X test"

RDEPEND="
	>=x11-libs/libva-1.7[drm,X?,${MULTILIB_USEDEP}]
	v4l? (
		>=virtual/opengl-7[${MULTILIB_USEDEP}]
		>=media-libs/libv4l-1.6.2[${MULTILIB_USEDEP}]
		>=media-libs/mesa-10[egl,gles2,${MULTILIB_USEDEP}]
	)
	X? ( >=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}] )
	md5? ( dev-libs/openssl:0=[${MULTILIB_USEDEP}] )
	dmabuf? ( x11-libs/libdrm[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	test? ( >=dev-cpp/gtest-1.7 )
"

src_prepare() {
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable debug) \
		$(use_enable v4l v4l2) \
		$(use_enable v4l v4l2-ops) \
		$(use_enable capi) \
		$(use_enable X x11) \
		$(use_enable dmabuf) \
		$(use_enable md5) \
		$(use_enable test gtest) \
		$(multilib_native_use_enable doc docs) \
		--enable-h265dec \
		--enable-vc1dec \
		--enable-h264dec \
		--enable-jpegdec \
		--enable-mpeg2dec \
		--enable-vp8dec \
		--enable-vp9dec \
		--enable-h265enc \
		--enable-h264enc \
		--enable-jpegenc \
		--enable-vp8enc
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
