# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome.org meson multilib-minimal virtualx

DESCRIPTION="C++ interface for GTK+"
HOMEPAGE="https://www.gtkmm.org"

LICENSE="LGPL-2.1+"
SLOT="3.0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 sparc ~x86 ~amd64-linux ~x86-linux ~x86-solaris"

IUSE="aqua doc test wayland X"
REQUIRED_USE="|| ( aqua wayland X )"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-cpp/atkmm-2.24.2:0[doc?,${MULTILIB_USEDEP}]
	>=dev-cpp/cairomm-1.12.0:0[doc?,${MULTILIB_USEDEP}]
	>=dev-cpp/glibmm-2.54.0:2[doc?,${MULTILIB_USEDEP}]
	>=dev-cpp/pangomm-2.38.2:1.4[doc?,${MULTILIB_USEDEP}]
	>=dev-libs/libsigc++-2.3.2:2[doc?,${MULTILIB_USEDEP}]
	>=media-libs/libepoxy-1.2[${MULTILIB_USEDEP}]
	>=x11-libs/gdk-pixbuf-2.35.5:2[${MULTILIB_USEDEP}]
	>=x11-libs/gtk+-3.24.0:3[aqua?,wayland?,X?,${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-doc/doxygen[dot]
		dev-lang/perl
		dev-libs/libxslt
	)
"

multilib_src_configure() {
	local emesonargs=(
		-Dbuild-atkmm-api=true
		-Dbuild-demos=false
		-Dbuild-documentation=$(multilib_native_usex doc true false)
		-Dbuild-tests=$(usex test true false)
		-Dbuild-x11-api=$(usex X true false)
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_install() {
	meson_src_install
}

multilib_src_test() {
	virtx meson_src_test
}
