# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

DESCRIPTION="A client-side decorations library for Wayland clients"
HOMEPAGE="https://gitlab.freedesktop.org/libdecor/libdecor"
if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/libdecor/libdecor.git"
	inherit git-r3
else
	SRC_URI="https://gitlab.freedesktop.org/libdecor/libdecor/-/archive/${PV}/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi
LICENSE="MIT"
SLOT="0"
IUSE="+dbus +gtk examples"

RDEPEND="
	>=dev-libs/wayland-1.18[${MULTILIB_USEDEP}]
	x11-libs/pango[${MULTILIB_USEDEP}]
	x11-libs/cairo[${MULTILIB_USEDEP}]
	dbus? ( sys-apps/dbus[${MULTILIB_USEDEP}] )
	gtk? ( x11-libs/gtk+:3[${MULTILIB_USEDEP}] )
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

multilib_src_configure() {
	local emesonargs=(
		# Avoid auto-magic, built-in feature of meson
		-Dauto_features=disabled
		$(meson_feature gtk)
		$(meson_feature dbus)
		$(meson_native_use_bool examples demo)
		-Dinstall_demo=true
	)

	meson_src_configure
}
