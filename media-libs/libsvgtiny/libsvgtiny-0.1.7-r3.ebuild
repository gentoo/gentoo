# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit netsurf

DESCRIPTION="Small and portable C library to parse SVG"
HOMEPAGE="https://www.netsurf-browser.org/projects/libsvgtiny/"
SRC_URI="https://download.netsurf-browser.org/libs/releases/${P}-src.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE=""

RDEPEND="
	net-libs/libdom[xml]
	dev-libs/libwapcaplet"
DEPEND="${RDEPEND}
	dev-util/gperf"
BDEPEND="
	>=dev-util/netsurf-buildsystem-1.9-r2
	virtual/pkgconfig"

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
