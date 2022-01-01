# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit epatch

MY_PN="input"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Small collection of linux input layer utils"
HOMEPAGE="https://www.kraxel.org/blog/linux/input/"
SRC_URI="https://www.kraxel.org/releases/input/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc x86"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# Ported from Debian
	#epatch "${FILESDIR}"/input-utils-0.0.1_pre20081014.patch
	# version check stuff
	#epatch "${FILESDIR}"/input-utils-0.0.1-protocol-mismatch-fix.patch
	:
}

src_install() {
	make install bindir="${D}"/usr/bin mandir="${D}"/usr/share/man STRIP="" || die "make install failed"
	dodoc lircd.conf
	dodoc README
}
