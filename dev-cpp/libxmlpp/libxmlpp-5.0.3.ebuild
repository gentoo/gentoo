# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GNOME_ORG_MODULE="${PN/pp/++}"

inherit gnome2 meson

DESCRIPTION="C++ wrapper for the libxml2 XML parser library"
HOMEPAGE="http://libxmlplusplus.sourceforge.net/"

LICENSE="LGPL-2.1"
SLOT="5.0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/libxml2-2.7.7
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? (
		dev-cpp/mm-common
		app-text/doxygen
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

src_configure() {
	local emesonargs=(
		-Dmaintainer-mode=false
		-Dwarnings=min
		-Ddist-warnings=max
		-Dbuild-deprecated-api=true
		$(meson_use doc build-documentation)
		-Dvalidation=false
		-Dbuild-pdf=false
		-Dbuild-examples=false
		$(meson_use test build-tests)
		-Dmsvc14x-parallel-installable=false
	)
	meson_src_configure
}
