# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson systemd

DESCRIPTION="Backend implementation for xdg-desktop-portal using Cinnamon/MATE/Xfce"
HOMEPAGE="https://github.com/linuxmint/xdg-desktop-portal-xapp/"
SRC_URI="https://github.com/linuxmint/xdg-desktop-portal-xapp/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"

DEPEND="
	>=dev-libs/glib-2.44:2
	>=sys-apps/xdg-desktop-portal-1.5
	x11-libs/gtk+:3
"
RDEPEND="
	${DEPEND}
	sys-apps/xdg-desktop-portal-gtk
	>=x11-libs/xapp-2.8.9
"
BDEPEND="
	dev-util/gdbus-codegen
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	# Fix accent color settings
	# https://github.com/linuxmint/xdg-desktop-portal-xapp/commit/326aadd4972d62a3ebccb93ad5c028977ce4ac95
	"${FILESDIR}/${PN}-${PV}-fix-accent-color-settings.patch"
)

src_configure() {
	local emesonargs=(
		-Dsystemduserunitdir="$(systemd_get_userunitdir)"
	)
	meson_src_configure
}
