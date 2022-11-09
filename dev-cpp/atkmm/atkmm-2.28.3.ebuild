# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit gnome.org meson-multilib python-any-r1

DESCRIPTION="C++ interface for the ATK library"
HOMEPAGE="https://www.gtkmm.org https://gitlab.gnome.org/GNOME/atkmm"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv sparc ~x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE="gtk-doc"

DEPEND="
	>=dev-cpp/glibmm-2.46.2:2[gtk-doc?,${MULTILIB_USEDEP}]
	>=dev-libs/atk-2.18.0[${MULTILIB_USEDEP}]
	>=dev-libs/libsigc++-2.3.2:2[gtk-doc?,${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	gtk-doc? (
		>=dev-cpp/mm-common-1.0.4
		app-doc/doxygen[dot]
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
