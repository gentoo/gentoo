# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_PV=${PV/_beta/b}
MY_P=${PN}-${MY_PV}

DESCRIPTION="CAB file creation tool"
HOMEPAGE="http://ohnopub.net/lcab/"
SRC_URI="ftp://mirror.ohnopub.net/mirror/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	sed -i "s:1.0b11:${MY_PV}:" mytypes.h || die
	eautoreconf
}

src_install() {
	default
	doman ${PN}.1
}
