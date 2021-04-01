# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome.org meson multilib-minimal

DESCRIPTION="C++ interface for glib2"
HOMEPAGE="https://www.gtkmm.org"

LICENSE="LGPL-2.1+"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE="doc debug test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/libsigc++-2.9.1:2[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.61.2:2[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	>=dev-cpp/mm-common-1.0.0
	sys-devel/m4
	dev-lang/perl
	doc? (
		app-doc/doxygen
		dev-libs/libxslt
		media-gfx/graphviz
	)
"

src_prepare() {
	default

	# giomm_tls_client requires FEATURES=-network-sandbox and glib-networking rdep
	sed -i -e '/giomm_tls_client/d' tests/meson.build || die

	if ! use test; then
		sed -i -e "/^subdir('tests')/d" meson.build || die
	fi
}

multilib_src_configure() {
	local emesonargs=(
		-Dmaintainer-mode=true # Set false and drop mm-common dep once tarballs are made with meson/ninja
		-Dwarnings=min
		-Dbuild-deprecated-api=true
		-Dbuild-documentation=$(usex doc true false)
		-Ddebug-refcounting=$(usex debug true false)
		-Dbuild-examples=false
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_test() {
	meson_src_test
}

multilib_src_install() {
	meson_src_install
}
