# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Network packet generator and capture tool"
HOMEPAGE="https://github.com/resurrecting-open-source-projects/packit"
SRC_URI="https://github.com/resurrecting-open-source-projects/packit/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

DEPEND="net-libs/libnet:1.1
	net-libs/libpcap"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	eautoreconf
}

src_install() {
	default

	dodoc docs/*
}
