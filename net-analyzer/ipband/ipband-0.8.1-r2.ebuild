# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Pcap based IP traffic and bandwidth monitor"
HOMEPAGE="https://ipband.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 x86"

DEPEND="
	>=net-libs/libpcap-0.4
"
RDEPEND="
	${DEPEND}
"
PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-postfix.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_configure() {
	tc-export CC
	default
}

src_install() {
	dobin ipband
	doman ipband.8
	dodoc CHANGELOG README

	newinitd "${FILESDIR}"/ipband-init ipband

	insinto /etc/
	newins ipband.sample.conf ipband.conf
}
