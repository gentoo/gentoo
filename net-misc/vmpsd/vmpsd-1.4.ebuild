# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="An open-source VLAN management system"
HOMEPAGE="http://vmps.sourceforge.net"
SRC_URI="mirror://sourceforge/vmps/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="net-analyzer/net-snmp:=[ucd-compat(+)]"
DEPEND="
	${RDEPEND}
	dev-libs/openssl"

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4-snmp-support.patch
	"${FILESDIR}"/${PN}-1.3-64bit.patch
	"${FILESDIR}"/${PN}-1.4-Wreturn-type.patch
)

src_prepare() {
	default
	mv configure.{in,ac} || die
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
