# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit git-r3 netsurf

DESCRIPTION="string internment library, written in C"
HOMEPAGE="https://www.netsurf-browser.org/projects/libwapcaplet/"
EGIT_REPO_URI="git://git.netsurf-browser.org/${PN}.git"

LICENSE="MIT"
SLOT="0/${PV}"
IUSE="test"

RESTRICT="!test? ( test )"

DEPEND="
	test? ( >=dev-libs/check-0.9.11 )"
BDEPEND="
	>=dev-build/netsurf-buildsystem-1.7-r1"

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
