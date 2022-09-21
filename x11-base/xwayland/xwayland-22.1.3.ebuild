# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/xorg/xserver.git"
	inherit git-r3
else
	SRC_URI="https://xorg.freedesktop.org/archive/individual/xserver/${P}.tar.xz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="Standalone X server running under Wayland"
HOMEPAGE="https://wayland.freedesktop.org/xserver.html"

IUSE="selinux video_cards_nvidia unwind xcsecurity"

LICENSE="MIT"
SLOT="0"

COMMON_DEPEND="
	dev-libs/libbsd
	dev-libs/openssl:=
	>=dev-libs/wayland-1.20
	>=dev-libs/wayland-protocols-1.22
	media-fonts/font-util
	>=media-libs/libepoxy-1.5.4[X,egl(+)]
	media-libs/libglvnd[X]
	>=media-libs/mesa-21.1[X(+),egl(+),gbm(+)]
	>=x11-libs/libdrm-2.4.89
	>=x11-libs/libXau-1.0.4
	x11-libs/libxcvt
	>=x11-libs/libXdmcp-1.0.2
	>=x11-libs/libXfont2-2.0.1
	x11-libs/libxkbfile
	>=x11-libs/libxshmfence-1.1
	>=x11-libs/pixman-0.27.2
	>=x11-misc/xkeyboard-config-2.4.1-r3

	unwind? ( sys-libs/libunwind )
	video_cards_nvidia? ( gui-libs/egl-wayland )
"
DEPEND="
	${COMMON_DEPEND}
	x11-base/xorg-proto
	>=x11-libs/xtrans-1.3.5
"
RDEPEND="
	${COMMON_DEPEND}
	x11-apps/xkbcomp
	!<=x11-base/xorg-server-1.20.11
	selinux? ( sec-policy/selinux-xserver )
"
BDEPEND="
	sys-devel/flex
	dev-util/wayland-scanner
"

PATCHES=(
	"${FILESDIR}"/xwayland-drop-redundantly-installed-files.patch
)

src_configure() {
	local emesonargs=(
		$(meson_use selinux xselinux)
		$(meson_use unwind libunwind)
		$(meson_use xcsecurity)
		$(meson_use video_cards_nvidia xwayland_eglstream)
		-Ddpms=true
		-Ddri3=true
		-Ddrm=true
		-Ddtrace=false
		-Dglamor=true
		-Dglx=true
		-Dipv6=true
		-Dsecure-rpc=false
		-Dscreensaver=true
		-Dsha1=libcrypto
		-Dxace=true
		-Dxdmcp=true
		-Dxinerama=true
		-Dxvfb=true
		-Dxv=true
		-Dxwayland-path="${EPREFIX}"/usr/bin
		-Ddocs=false
		-Ddevel-docs=false
		-Ddocs-pdf=false
	)

	meson_src_configure
}

src_install() {
	dosym ../bin/Xwayland /usr/libexec/Xwayland

	meson_src_install
}
