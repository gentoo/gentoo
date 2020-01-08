# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4
inherit eutils flag-o-matic autotools

DESCRIPTION="An open-source VLAN management system"
HOMEPAGE="http://vmps.sourceforge.net"
SRC_URI="mirror://sourceforge/vmps/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
DEPEND="net-analyzer/net-snmp[ucd-compat(+)]
	dev-libs/openssl"
S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.4-snmp-support.patch
	epatch "${FILESDIR}"/${PN}-1.3-64bit.patch
	# Merged upstream
	#EPATCH_OPTS="-d${S}" \
	#epatch "${FILESDIR}"/${PN}-1.3-format-sec.patch
	eautoreconf
}

src_configure() {
	econf \
		--sysconfdir=/etc/vmpsd \
		--enable-snmp \
		LIBS="-lssl"
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README INSTALL AUTHORS doc/*txt
	newdoc external/README README.external
	newdoc tools/README README.tools
	dodoc external/simple tools/vqpcli.pl
}
