# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

DESCRIPTION="VDPAU Backend for Video Acceleration (VA) API"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/vaapi"
SRC_URI="https://www.freedesktop.org/software/vaapi/releases/libva-vdpau-driver/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm64 x86"
IUSE="debug opengl"

RDEPEND=">=x11-libs/libva-1.2.1-r1:=[X,opengl?,${MULTILIB_USEDEP}]
	opengl? ( >=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}] )
	>=x11-libs/libvdpau-0.8[${MULTILIB_USEDEP}]
	!x11-libs/vdpau-video"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( NEWS README AUTHORS )

PATCHES=(
	"${FILESDIR}"/${P}-glext-missing-definition.patch
	"${FILESDIR}"/${P}-VAEncH264VUIBufferType.patch
	"${FILESDIR}"/${P}-libvdpau-0.8.patch
	"${FILESDIR}"/${P}-sigfpe-crash.patch
	"${FILESDIR}"/${P}-include-linux-videodev2.h.patch
)

src_prepare() {
	default
	sed -i 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.ac || die
	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(use_enable opengl glx)
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}
