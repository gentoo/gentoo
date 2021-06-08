# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit gnome.org meson-multilib python-any-r1

DESCRIPTION="C++ interface for pango"
HOMEPAGE="https://www.gtkmm.org"

LICENSE="LGPL-2.1+"
SLOT="1.4"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE="doc"

DEPEND="
	>=dev-cpp/cairomm-1.2.2:0[doc?,${MULTILIB_USEDEP}]
	>=dev-cpp/glibmm-2.48.0:2[doc?,${MULTILIB_USEDEP}]
	dev-libs/libsigc++:2[doc?,${MULTILIB_USEDEP}]
	>=x11-libs/pango-1.41.0[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-doc/doxygen[dot]
		dev-lang/perl
		dev-libs/libxslt
	)
	${PYTHON_DEPS}
"

multilib_src_configure() {
	local emesonargs=(
		$(meson_native_use_bool doc build-documentation)
	)
	meson_src_configure
}
