# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit flag-o-matic git-r3 netsurf

DESCRIPTION="HTML5 compliant parsing library, written in C"
HOMEPAGE="https://www.netsurf-browser.org/projects/hubbub/"
EGIT_REPO_URI="git://git.netsurf-browser.org/${PN}.git"

LICENSE="MIT"
SLOT="0/${PV}"
IUSE="doc test"

BDEPEND="
	dev-build/netsurf-buildsystem
	dev-util/gperf
	virtual/pkgconfig
	doc? ( app-text/doxygen )
	test? ( dev-lang/perl )
"
RDEPEND="dev-libs/libparserutils:="
DEPEND="${RDEPEND}
	test? ( dev-libs/json-c )"
RESTRICT="!test? ( test )"

DOCS=( README docs/{Architecture,Macros,Todo,Treebuilder,Updated} )

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
