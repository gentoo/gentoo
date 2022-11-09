# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

DESCRIPTION="Install firmware on devices"
HOMEPAGE="https://gitlab.gnome.org/World/gnome-firmware"
SRC_URI="https://people.freedesktop.org/~hughsient/releases/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+man elogind systemd"

RDEPEND="
	>=gui-libs/gtk-4.2:4
	dev-libs/glib:2
	>=sys-apps/fwupd-1.7.5[elogind?,systemd?]
	>=dev-libs/libxmlb-0.1.7:=
	>=gui-libs/libadwaita-1.0.0:1
	elogind? ( sys-auth/elogind )
	systemd? ( sys-apps/systemd )
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
	man? ( sys-apps/help2man )
"

DOCS=( README.md )

PATCHES=(
	# https://gitlab.gnome.org/World/gnome-firmware/-/issues/47
	"${FILESDIR}/${P}-build-failure.patch"
)

src_configure() {
	local emesonargs=(
		-Dconsolekit=false
		-Ddevel=false
		$(meson_use elogind)
		$(meson_use man)
		$(meson_use systemd)
	)
	meson_src_configure
}
