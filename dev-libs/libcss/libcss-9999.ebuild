# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 netsurf

DESCRIPTION="CSS parser and selection engine, written in C"
HOMEPAGE="https://www.netsurf-browser.org/projects/libcss/"

EGIT_REPO_URI="https://git.netsurf-browser.org/${PN}.git"
LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS=""
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/libparserutils
	dev-libs/libwapcaplet"
DEPEND="${RDEPEND}
	test? ( dev-lang/perl )"
BDEPEND="
	dev-util/netsurf-buildsystem
	virtual/pkgconfig"

src_prepare() {
	default
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
