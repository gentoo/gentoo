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
	KEYWORDS="amd64 ~arm64 ~ppc64 x86"
fi

LICENSE="MIT"
SLOT="0/9999"
IUSE="elogind systemd"
REQUIRED_USE="?? ( elogind systemd )"

DEPEND="
	>=media-video/pipewire-0.3.2:=
	dev-libs/wayland
	>=dev-libs/wayland-protocols-1.14:=
	elogind? ( >=sys-auth/elogind-237 )
	systemd? ( >=sys-apps/systemd-237 )
"
RDEPEND="
	${DEPEND}
	sys-apps/xdg-desktop-portal
"
BDEPEND="
	>=media-video/pipewire-0.3.2:=
	>=dev-libs/wayland-protocols-1.14
	dev-libs/inih:0
	virtual/pkgconfig
"
