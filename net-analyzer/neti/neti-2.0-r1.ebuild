# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="NETI@Home research project from GATech"
HOMEPAGE="http://www.neti.gatech.edu"
SRC_URI="mirror://sourceforge/neti/${P}.tar.gz"

KEYWORDS="~ppc x86"
LICENSE="GPL-2"
SLOT="0"
IUSE="zlib java"

DEPEND="
	java? ( || ( >=virtual/jdk-1.2 >=virtual/jre-1.2 ) )
	net-libs/libpcap
"
RDEPEND="${DEPEND}"

RESTRICT="test"

src_configure() {
	econf $(use_with zlib)
}

src_compile() {
	emake NETILogParse neti

	use java && emake javadir=/usr/share/${PN} classjava.stamp
}

src_install() {
	emake \
		DESTDIR="${D}" \
		install-sbinPROGRAMS \
		install-sysconfDATA \
		install-man \
		install-info

	if use java; then
		emake \
			DESTDIR="${D}" \
			javadir=/usr/share/${PN} \
			install-javaJAVA \
			install-javaDATA

		echo cd /usr/share/${PN}\;java -cp /usr/share/${PN} NETIMap > "${WORKDIR}"/NETIMap
		dobin "${WORKDIR}"/NETIMap
	fi

	dodoc README AUTHORS
	newinitd "${FILESDIR}"/neti-init2 neti
}
