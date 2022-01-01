# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Standalone X server running under Wayland"
HOMEPAGE="https://wayland.freedesktop.org/xserver.html"
SRC_URI="https://xorg.freedesktop.org/archive/individual/xserver/${P}.tar.xz"

IUSE="rpc unwind ipv6 xcsecurity selinux"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

CDEPEND="
	>=x11-libs/pixman-0.27.2
	dev-libs/libbsd
	>=x11-libs/libXfont2-2.0.1
	dev-libs/openssl:=
	dev-libs/wayland
	>=x11-libs/libXdmcp-1.0.2
	>=x11-libs/libdrm-2.4.89
	>=media-libs/libepoxy-1.5.4[X,egl(+)]
	>=media-libs/mesa-18[X(+),egl,gbm]
	>=x11-libs/libxshmfence-1.1
	rpc? ( net-libs/libtirpc )
	>=x11-libs/libXau-1.0.4
	media-libs/libglvnd[X]
	unwind? ( sys-libs/libunwind )
	>=dev-libs/wayland-protocols-1.18
	media-fonts/font-util
	x11-libs/libxkbfile
	>=x11-libs/xtrans-1.3.5
	x11-base/xorg-proto
	>=x11-misc/xkeyboard-config-2.4.1-r3
"

DEPEND="
	${CDEPEND}
	!<=x11-base/xorg-server-1.20.11
"

RDEPEND="
	${DEPEND}
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
		$(meson_use rpc secure-rpc)
		$(meson_use unwind libunwind)
		$(meson_use ipv6)
		$(meson_use xcsecurity)
		$(meson_use selinux xselinux)
		-Dsha1=libcrypto
		-Ddpms=true
		-Ddri3=true
		-Dglamor=true
		-Dglx=true
		-Dscreensaver=true
		-Dxace=true
		-Dxdmcp=true
		-Dxinerama=true
		-Dxv=true
		-Dxvfb=true
		-Dxwayland-path="${EPREFIX}"/usr/libexec
		-Ddtrace=false
	)

	meson_src_configure
}

src_install() {
	dosym ../libexec/Xwayland /usr/bin/Xwayland

	meson_src_install
}
