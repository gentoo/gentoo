# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic netsurf

DESCRIPTION="C library for building efficient parsers"
HOMEPAGE="http://www.netsurf-browser.org/projects/libparserutils/"
SRC_URI="https://download.netsurf-browser.org/libs/releases/${P}-src.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ppc ~ppc64 x86"
IUSE="iconv test"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-util/netsurf-buildsystem-1.7-r1
	test? (	dev-lang/perl )"

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
