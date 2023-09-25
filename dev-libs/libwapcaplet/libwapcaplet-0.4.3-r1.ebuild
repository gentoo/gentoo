# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit netsurf

DESCRIPTION="string internment library, written in C"
HOMEPAGE="https://www.netsurf-browser.org/projects/libwapcaplet/"
SRC_URI="https://download.netsurf-browser.org/libs/releases/${P}-src.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="test"

RESTRICT="!test? ( test )"

DEPEND="
	test? ( >=dev-libs/check-0.9.11 )"
BDEPEND="
	>=dev-util/netsurf-buildsystem-1.7-r1"

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
