# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{7..10} )
inherit gnome.org meson-multilib python-any-r1

DESCRIPTION="C++ interface for glib2"
HOMEPAGE="https://www.gtkmm.org"

LICENSE="LGPL-2.1+"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE="doc debug test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/libsigc++-2.9.1:2[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.61.2:2[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
	doc? (
		app-doc/doxygen[dot]
		dev-lang/perl
		dev-perl/XML-Parser
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
		-Dwarnings=min
		-Dbuild-deprecated-api=true
		$(meson_native_use_bool doc build-documentation)
		$(meson_use debug debug-refcounting)
		-Dbuild-examples=false
	)
	meson_src_configure
}
