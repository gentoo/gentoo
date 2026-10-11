# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit flag-o-matic git-r3 netsurf

DESCRIPTION="C library for building efficient parsers"
HOMEPAGE="https://www.netsurf-browser.org/projects/libparserutils/"
EGIT_REPO_URI="git://git.netsurf-browser.org/${PN}.git"

LICENSE="MIT"
SLOT="0/${PV}"
IUSE="iconv test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-build/netsurf-buildsystem
	test? (	dev-lang/perl )
"

DOCS=( README docs/Todo )

src_configure() {
	append-cflags "-D$(usex iconv WITH WITHOUT)_ICONV_FILTER"
}

_emake() {
	netsurf_define_makeconf
	emake "${NETSURF_MAKECONF[@]}" COMPONENT_TYPE=lib-shared $@
}

src_compile() {
	_emake
}

src_test() {
	_emake test
}

src_install() {
	_emake DESTDIR="${D}" install
}
