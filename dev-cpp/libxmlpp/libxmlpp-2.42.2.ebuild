# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GNOME_ORG_MODULE="${PN/pp/++}"

inherit gnome2 meson-multilib

DESCRIPTION="C++ wrapper for the libxml2 XML parser library"
HOMEPAGE="http://libxmlplusplus.sourceforge.net/"

LICENSE="LGPL-2.1"
SLOT="2.6"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/libxml2-2.7.7[${MULTILIB_USEDEP}]
	>=dev-cpp/glibmm-2.32.0:2[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? (
		dev-cpp/mm-common
		app-doc/doxygen
		media-gfx/graphviz
		dev-libs/libxslt
	)
"

src_prepare() {
	default

	sed -i \
		-e "/install_docdir = /s/'doc'/'gtk-doc'/" \
		docs/reference/meson.build || die
	sed -i \
		-e "/install_tutorialdir = /s/'doc'/'gtk-doc'/" \
		docs/manual/meson.build || die
}

multilib_src_configure() {
	local emesonargs=(
		-Dmaintainer-mode=false
		-Dwarnings=min
		-Ddist-warnings=max
		-Dbuild-deprecated-api=true
		$(meson_native_use_bool doc build-documentation)
		-Dvalidation=false
		-Dbuild-pdf=false
		-Dbuild-examples=false
		$(meson_use test build-tests)
		-Dmsvc14x-parallel-installable=false
	)
	meson_src_configure
}
