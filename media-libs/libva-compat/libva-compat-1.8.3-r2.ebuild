# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal optfeature

MY_PN="${PN%-compat}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Video Acceleration (VA) API for Linux"
HOMEPAGE="https://01.org/linuxmedia/vaapi"
SRC_URI="https://github.com/01org/libva/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="1"
KEYWORDS="amd64 arm64 x86 ~amd64-linux ~x86-linux"
IUSE="+drm egl opengl wayland X"

RDEPEND=">=x11-libs/libdrm-2.4.46[${MULTILIB_USEDEP}]
	X? (
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXfixes-5.0.1[${MULTILIB_USEDEP}]
	)
	egl? ( >=media-libs/mesa-9.1.6[egl(+),${MULTILIB_USEDEP}] )
	opengl? ( >=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}] )
	wayland? ( >=dev-libs/wayland-1.0.6[${MULTILIB_USEDEP}] )
	!media-libs/libva:0/0"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

REQUIRED_USE="|| ( drm wayland X )
		opengl? ( X )"

S="${WORKDIR}/${MY_P}"
DOCS=( NEWS )

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		--with-drivers-path="${EPREFIX}/usr/$(get_libdir)/va/drivers"
		$(use_enable opengl glx)
		$(use_enable X x11)
		$(use_enable wayland)
		$(use_enable egl)
		$(use_enable drm)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install() {
	emake -C va DESTDIR="${D}" install-libLTLIBRARIES
	rm -vf "${ED}"/usr/$(get_libdir)/*.{la,so} || die
}

pkg_postinst() {
	optfeature_header
	optfeature "Older Intel GPU support" media-libs/libva-intel-driver
	optfeature "Newer Intel GPU support" media-libs/libva-intel-media-driver
}
