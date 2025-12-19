# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit gnome.org meson-multilib python-any-r1

DESCRIPTION="C++ interface for pango"
HOMEPAGE="https://gtkmm.gnome.org/en/index.html"

LICENSE="LGPL-2.1+"
SLOT="2.48"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="gtk-doc"

RDEPEND="
	>=dev-cpp/cairomm-1.16.0:1.16[gtk-doc?,${MULTILIB_USEDEP}]
	>=dev-cpp/glibmm-2.68.0:2.68[gtk-doc?,${MULTILIB_USEDEP}]
	>=dev-libs/libsigc++-3:3[gtk-doc?,${MULTILIB_USEDEP}]
	>=x11-libs/pango-1.56.0[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
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
		-Dmaintainer-mode=false
		$(meson_native_use_bool gtk-doc build-documentation)
	)
	meson_src_configure
}
