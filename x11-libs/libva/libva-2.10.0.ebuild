# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

DESCRIPTION="Video Acceleration (VA) API for Linux"
HOMEPAGE="https://01.org/linuxmedia/vaapi"

if [[ ${PV} = *9999 ]] ; then
	inherit git-r3
	EGIT_BRANCH=master
	EGIT_REPO_URI="https://github.com/intel/libva"
else
	SRC_URI="https://github.com/intel/libva/releases/download/${PV}/${P}.tar.bz2"
	KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv x86 ~amd64-linux ~x86-linux"
fi

LICENSE="MIT"
SLOT="0/$(ver_cut 1)"
IUSE="+drm opengl utils vdpau wayland X"

VIDEO_CARDS="nvidia intel i965 nouveau"
for x in ${VIDEO_CARDS}; do
	IUSE+=" video_cards_${x}"
done

RDEPEND="
	>=x11-libs/libdrm-2.4.46[${MULTILIB_USEDEP}]
	opengl? ( >=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}] )
	wayland? ( >=dev-libs/wayland-1.11[${MULTILIB_USEDEP}] )
	X? (
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXfixes-5.0.1[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"
PDEPEND="video_cards_nvidia? ( >=x11-libs/libva-vdpau-driver-0.7.4-r1[${MULTILIB_USEDEP}] )
	video_cards_nouveau? ( >=x11-libs/libva-vdpau-driver-0.7.4-r3[${MULTILIB_USEDEP}] )
	vdpau? ( >=x11-libs/libva-vdpau-driver-0.7.4-r1[${MULTILIB_USEDEP}] )
	video_cards_intel? ( >=x11-libs/libva-intel-driver-2.0.0[${MULTILIB_USEDEP}] )
	video_cards_i965? ( >=x11-libs/libva-intel-driver-2.0.0[${MULTILIB_USEDEP}] )
	utils? ( media-video/libva-utils )
"

REQUIRED_USE="|| ( drm wayland X )
	opengl? ( X )"

DOCS=( NEWS )

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/va/va_backend_glx.h
	/usr/include/va/va_x11.h
	/usr/include/va/va_dri2.h
	/usr/include/va/va_dricommon.h
	/usr/include/va/va_glx.h
)

PATCHES=(
	"${FILESDIR}/${PN}-2.10.0-fix_wayland_build.patch"
)

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
		$(use_enable drm)
		--enable-va-messaging
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	default
	find "${ED}" -type f -name "*.la" -delete || die
}
