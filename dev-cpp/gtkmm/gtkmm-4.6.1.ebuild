# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit gnome.org meson python-any-r1 virtualx

DESCRIPTION="C++ interface for GTK+"
HOMEPAGE="https://www.gtkmm.org"

LICENSE="LGPL-2.1+"
SLOT="4.0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="doc test"

RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-cpp/glibmm-2.68.0:2.68[doc?]
	>=gui-libs/gtk-4.6.0:4
	>=dev-cpp/cairomm-1.15.4:1.16[doc?]
	>=dev-cpp/pangomm-2.50.0:2.48[doc?]
	>=x11-libs/gdk-pixbuf-2.35.5:2
	>=media-libs/libepoxy-1.2
"
DEPEND="
	${RDEPEND}
	doc? ( dev-libs/libsigc++:3 )
"
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-doc/doxygen[dot]
		dev-lang/perl
		dev-libs/libxslt
	)
	${PYTHON_DEPS}
"

src_configure() {
	local emesonargs=(
		-Dbuild-demos=false
		$(meson_use doc build-documentation)
		$(meson_use test build-tests)
	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}
