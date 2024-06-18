# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/xorg/xserver.git"
	inherit git-r3
else
	SRC_URI="https://xorg.freedesktop.org/archive/individual/xserver/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="Standalone X server running under Wayland"
HOMEPAGE="https://wayland.freedesktop.org/xserver.html"

LICENSE="MIT"
SLOT="0"

IUSE="libei selinux systemd test unwind xcsecurity"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dev-libs/libbsd
	dev-libs/openssl:=
	>=dev-libs/wayland-1.21.0
	>=dev-libs/wayland-protocols-1.34
	media-fonts/font-util
	>=media-libs/libepoxy-1.5.4[X,egl(+)]
	media-libs/libglvnd[X]
	>=media-libs/mesa-21.1[X(+),egl(+),gbm(+)]
	>=x11-libs/libdrm-2.4.116
	>=x11-libs/libXau-1.0.4
	x11-libs/libxcvt
	>=x11-libs/libXdmcp-1.0.2
	>=x11-libs/libXfont2-2.0.1
	x11-libs/libxkbfile
	>=x11-libs/libxshmfence-1.1
	>=x11-libs/pixman-0.27.2
	>=x11-misc/xkeyboard-config-2.4.1-r3

	libei? ( dev-libs/libei )
	systemd? ( sys-apps/systemd )
	unwind? ( sys-libs/libunwind )
"
DEPEND="
	${COMMON_DEPEND}
	>=x11-base/xorg-proto-2024.1
	>=x11-libs/xtrans-1.3.5
	test? (
		x11-misc/rendercheck
		x11-libs/libX11
	)
"
RDEPEND="
	${COMMON_DEPEND}
	x11-apps/xkbcomp

	libei? ( >=sys-apps/xdg-desktop-portal-1.18.0 )
	selinux? ( sec-policy/selinux-xserver )
"
BDEPEND="
	app-alternatives/lex
	dev-util/wayland-scanner
"

src_prepare() {
	default

	if ! use test; then
		sed -i -e "s/dependency('x11')/disabler()/" meson.build || die
	fi
}

src_configure() {
	local emesonargs=(
		$(meson_use selinux xselinux)
		$(meson_use systemd systemd_notify)
		$(meson_use unwind libunwind)
		$(meson_use xcsecurity)
		-Ddpms=true
		-Ddri3=true
		-Ddrm=true
		-Ddtrace=false
		-Dglamor=true
		-Dglx=true
		-Dipv6=true
		-Dscreensaver=true
		-Dsha1=libcrypto
		-Dxace=true
		-Dxdmcp=true
		-Dxinerama=true
		-Dxvfb=true
		-Dxv=true
		-Dxwayland-path="${EPREFIX}"/usr/bin
		-Dlibdecor=false
		-Ddocs=false
		-Ddevel-docs=false
		-Ddocs-pdf=false
	)

	if [[ ${PV} == "9999" ]]; then
		emesonargs+=(
			-Dxorg=false
			-Dxnest=false
			-Dxvfb=false
			-Dxwayland=true
		)
	fi

	if use libei; then
		emesonargs+=( -Dxwayland_ei=portal )
	else
		emesonargs+=( -Dxwayland_ei=false )
	fi

	meson_src_configure
}

src_install() {
	dosym ../bin/Xwayland /usr/libexec/Xwayland

	meson_src_install

	# Remove files installed by x11-base/xorg-xserver
	rm \
		"${ED}"/usr/share/man/man1/Xserver.1 \
		"${ED}"/usr/$(get_libdir)/xorg/protocol.txt \
		|| die
}
