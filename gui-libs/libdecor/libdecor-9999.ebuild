# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="A client-side decorations library for Wayland clients"
HOMEPAGE="https://gitlab.freedesktop.org/libdecor/libdecor"
if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/libdecor/libdecor.git"
	inherit git-r3
else
	SRC_URI="https://gitlab.freedesktop.org/libdecor/libdecor/-/archive/${PV}/${P}.tar.bz2"
	KEYWORDS="~amd64"
fi
LICENSE="MIT"
SLOT="0"
IUSE="+dbus +gtk examples"

RDEPEND="
	>=dev-libs/wayland-1.18
	x11-libs/pango
	x11-libs/cairo
	dbus? ( sys-apps/dbus )
	gtk? ( x11-libs/gtk+:3 )
	examples? (
		media-libs/libglvnd
		x11-libs/libxkbcommon
	)
"

DEPEND="
	${RDEPEND}
	>=dev-libs/wayland-protocols-1.15
"

BDEPEND="
	dev-util/wayland-scanner
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		# Avoid auto-magic, built-in feature of meson
		-Dauto_features=disabled
		$(meson_feature gtk)
		$(meson_feature dbus)
		$(meson_use examples demo)
		-Dinstall_demo=true
	)

	meson_src_configure
}
