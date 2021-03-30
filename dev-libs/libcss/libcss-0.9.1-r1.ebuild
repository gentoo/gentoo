# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit netsurf

DESCRIPTION="CSS parser and selection engine, written in C"
HOMEPAGE="http://www.netsurf-browser.org/projects/libcss/"
SRC_URI="https://download.netsurf-browser.org/libs/releases/${P}-src.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/libparserutils
	dev-libs/libwapcaplet"
DEPEND="${RDEPEND}
	test? ( dev-lang/perl )"
BDEPEND="
	>=dev-util/netsurf-buildsystem-1.7-r1
	virtual/pkgconfig"

src_prepare() {
	default
	sed -e '1i#pragma GCC diagnostic ignored "-Wimplicit-fallthrough"' \
		-i src/parse/parse.c src/select/arena_hash.h || die
	sed -e '1i#pragma GCC diagnostic ignored "-Wmaybe-uninitialized"' \
		-i src/parse/parse.c src/select/computed.c || die
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
