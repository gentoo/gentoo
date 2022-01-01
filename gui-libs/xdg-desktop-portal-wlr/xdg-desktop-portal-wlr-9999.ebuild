# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="xdg-desktop-portal backend for wlroots"
HOMEPAGE="https://github.com/emersion/xdg-desktop-portal-wlr"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/emersion/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/emersion/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	#KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
	KEYWORDS=""
fi

LICENSE="MIT"
SLOT="0/9999"
IUSE="elogind systemd"
REQUIRED_USE="?? ( elogind systemd )"

DEPEND="
	>=media-video/pipewire-0.2.9:=
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
	>=media-video/pipewire-0.2.9:=
	>=dev-libs/wayland-protocols-1.14
	>=dev-util/meson-0.47.0
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		"-Dwerror=false"
	)
	if use systemd; then
		emesonargs+=("-DHAVE_SYSTEMD=1")
	else
		emesonargs+=("-DHAVE_ELOGIND=1")
	fi

	meson_src_configure
}
