# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs flag-o-matic

DESCRIPTION="HTML5 compliant parsing library, written in C"
HOMEPAGE="https://www.netsurf-browser.org/projects/hubbub/"
SRC_URI="https://download.netsurf-browser.org/libs/releases/${P}-src.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 arm ~ppc ~ppc64 ~x86 ~m68k-mint"
IUSE="doc test"

BDEPEND="
	dev-util/netsurf-buildsystem
	virtual/pkgconfig

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
	source /usr/share/netsurf-buildsystem/gentoo-helpers.sh
	netsurf_define_makeconf
	append-cflags -Wno-error
	emake "${NETSURF_MAKECONF[@]}" COMPONENT_TYPE=lib-shared $@
}

src_compile() {
	_emake
}

src_test() {
	_emake test
}

src_install() {
	_emake DESTDIR="${ED}" install
}
