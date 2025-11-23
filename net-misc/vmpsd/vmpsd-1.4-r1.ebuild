# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="An open-source VLAN management system"
HOMEPAGE="https://vmps.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/vmps/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="net-analyzer/net-snmp:=[ucd-compat(+)]"
DEPEND="
	${RDEPEND}
	dev-libs/openssl"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4-snmp-support.patch
	"${FILESDIR}"/${PN}-1.3-64bit.patch
	"${FILESDIR}"/${PN}-1.4-missing-includes.patch
	"${FILESDIR}"/${PN}-1.4-C23.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf \
		--sysconfdir="${EPREFIX}"/etc/vmpsd \
		--enable-snmp \
		LIBS="-lssl"
}

src_install() {
	default

	dodoc doc/*txt external/simple tools/vqpcli.pl
	newdoc external/README README.external
	newdoc tools/README README.tools
}
