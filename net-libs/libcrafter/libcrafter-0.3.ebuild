# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools eutils ltprune

DESCRIPTION="A high level C++ network packet sniffing and crafting library"
HOMEPAGE="https://github.com/pellegre/libcrafter"
SRC_URI="https://github.com/pellegre/${PN}/archive/version-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND="
	net-libs/libpcap
"
DEPEND="
	${RDEPEND}
"

S=${WORKDIR}/${PN}-version-${PV}/${PN}

src_prepare() {
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default

	prune_libtool_files
}
