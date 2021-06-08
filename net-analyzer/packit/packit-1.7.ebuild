# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="network packet generator and capture tool"
HOMEPAGE="https://github.com/resurrecting-open-source-projects/packit"
SRC_URI="https://github.com/resurrecting-open-source-projects/packit/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"

DEPEND="
	net-libs/libnet:1.1
	net-libs/libpcap
"
RDEPEND="${DEPEND}"
PATCHES=(
	"${FILESDIR}"/${PN}-1.0-noopt.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	dodoc docs/*
}
