# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="xdg-desktop-portal backend for wlroots"
HOMEPAGE="https://github.com/emersion/xdg-desktop-portal-wlr"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/emersion/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/emersion/${PN}/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
fi

LICENSE="MIT"
SLOT="0/9999"
IUSE="elogind systemd"
REQUIRED_USE="?? ( elogind systemd )"

DEPEND="
	>=media-video/pipewire-0.3.41:=
	dev-libs/inih
	dev-libs/wayland
	media-libs/mesa
	x11-libs/libdrm
	|| (
		systemd? ( >=sys-apps/systemd-237 )
		elogind? ( >=sys-auth/elogind-237 )
		sys-libs/basu
	)
"
# mesa is needed for gbm dep (which it hards sets to 'on')
RDEPEND="
	${DEPEND}
	sys-apps/xdg-desktop-portal
"
BDEPEND="
	>=dev-libs/wayland-protocols-1.24
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=()

	if use systemd; then
		emesonargs+=(-Dsd-bus-provider=libsystemd)
	elif use elogind; then
		emesonargs+=(-Dsd-bus-provider=libelogind)
	else
		emesonargs+=(-Dsd-bus-provider=basu)
	fi
	meson_src_configure
}
