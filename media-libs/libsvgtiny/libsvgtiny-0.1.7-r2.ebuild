# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit netsurf

DESCRIPTION="framebuffer abstraction library, written in C"
HOMEPAGE="http://www.netsurf-browser.org/projects/libsvgtiny/"
SRC_URI="https://download.netsurf-browser.org/libs/releases/${P}-src.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE=""

RDEPEND="
	>=net-libs/libdom-0.1.2-r1[xml]
	>=dev-libs/libwapcaplet-0.2.2-r1"
DEPEND="${RDEPEND}
	dev-util/gperf
	dev-util/netsurf-buildsystem
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-0.1.3-parallel-build.patch )

_emake() {
	netsurf_define_makeconf
	emake "${NETSURF_MAKECONF[@]}" COMPONENT_TYPE=lib-shared $@
}

src_compile() {
	_emake
}

src_install() {
	_emake DESTDIR="${D}" install
}
