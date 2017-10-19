# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Command line tool for the YubiKey PIV application"
SRC_URI="https://github.com/Yubico/yubico-piv-tool/archive/yubico-piv-tool-${PV}.tar.gz"
HOMEPAGE="https://developers.yubico.com/yubico-piv-tool/ https://github.com/Yubico/yubico-piv-tool"

LICENSE="BSD-2"
SLOT="0/1"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-libs/openssl:0=
	sys-apps/pcsc-lite"
DEPEND="dev-util/gengetopt
	sys-apps/help2man
	virtual/pkgconfig
	${RDEPEND}"

S=${WORKDIR}/${PN}-${P}

src_prepare() {
	default
	eautoreconf
}
