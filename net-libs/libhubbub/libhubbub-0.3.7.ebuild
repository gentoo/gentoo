# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit netsurf flag-o-matic

DESCRIPTION="HTML5 compliant parsing library, written in C"
HOMEPAGE="https://www.netsurf-browser.org/projects/hubbub/"
SRC_URI="https://download.netsurf-browser.org/libs/releases/${P}-src.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm arm64 ppc ~ppc64 x86"
IUSE="doc test"

BDEPEND="
	dev-util/netsurf-buildsystem
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	test? ( dev-lang/perl )
"
RDEPEND="dev-libs/libparserutils:="
DEPEND="${RDEPEND}
	test? ( dev-libs/json-c )"
RESTRICT="!test? ( test )"

DOCS=( README docs/{Architecture,Macros,Todo,Treebuilder,Updated} )
PATCHES=( "${FILESDIR}/libhubbub-0.3.6-json-c.patch" )

src_prepare() {
	default
	sed -e '1i#pragma GCC diagnostic ignored "-Wimplicit-fallthrough"' \
		-i test/tree2.c || die
}

_emake() {
	netsurf_define_makeconf
	append-cflags -Wno-error
	emake "${NETSURF_MAKECONF[@]}" COMPONENT_TYPE=lib-shared $@
}

src_compile() {
	_emake
	use doc && _emake docs
}

src_test() {
	_emake test
}

src_install() {
	_emake DESTDIR="${D}" install
	use doc && HTML_DOCS=( docs/html/. )
	einstalldocs
}
