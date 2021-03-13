# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson multilib-minimal

DESCRIPTION="C++ bindings for the Cairo vector graphics library"
HOMEPAGE="https://cairographics.org/cairomm/"
SRC_URI="https://www.cairographics.org/releases/${P}.tar.xz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/libsigc++-2.6.0:2[doc?,${MULTILIB_USEDEP}]
	>=x11-libs/cairo-1.12.0[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		dev-libs/boost[${MULTILIB_USEDEP}]
		media-libs/fontconfig[${MULTILIB_USEDEP}]
	)
"
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
		-Dbuild-documentation=$(multilib_native_usex doc true false)
		-Dbuild-examples=false
		-Dbuild-tests=$(usex test true false)
		-Dboost-shared=true
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
	meson_src_test
}
