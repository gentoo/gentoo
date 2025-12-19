# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit gnome.org meson-multilib python-any-r1

DESCRIPTION="C++ interface for the ATK library"
HOMEPAGE="https://gtkmm.gnome.org https://gitlab.gnome.org/GNOME/atkmm"

LICENSE="LGPL-2.1+"
SLOT="2.36"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="gtk-doc"

DEPEND="
	dev-cpp/glibmm:2.68[gtk-doc?,${MULTILIB_USEDEP}]
	>=dev-libs/atk-2.33.3[${MULTILIB_USEDEP}]
	dev-libs/libsigc++:3[gtk-doc?,${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	gtk-doc? (
		>=dev-cpp/mm-common-1.0.4
		app-text/doxygen[dot]
		dev-libs/libxslt
	)
	${PYTHON_DEPS}
"

multilib_src_configure() {
	local emesonargs=(
		$(meson_native_use_bool gtk-doc build-documentation)
	)
	meson_src_configure
}
