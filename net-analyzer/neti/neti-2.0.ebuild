# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="NETI@Home research project from GATech"
HOMEPAGE="http://www.neti.gatech.edu"
SRC_URI="mirror://sourceforge/neti/${P}.tar.gz"

KEYWORDS="~ppc x86"
LICENSE="GPL-2"
SLOT="0"
IUSE="zlib java"

DEPEND="java? ( || ( >=virtual/jdk-1.2 >=virtual/jre-1.2 ) )
	net-libs/libpcap"
RDEPEND="${DEPEND}"

RESTRICT="test"

src_compile() {
	econf \
		$(use_with zlib) \
		 || die "econf failed"

	emake NETILogParse neti \
		|| die "emake NETILogParse neti failed"

	if use java;
	then
		emake javadir=/usr/share/${PN} classjava.stamp || die "emake classjava.stamp failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install-sbinPROGRAMS \
		install-sysconfDATA install-man install-info || die "emake install failed"

	if use java;
	then
		emake javadir=/usr/share/${PN} \
			 DESTDIR="${D}" install-javaJAVA install-javaDATA || die "emake java install failed"
		dobin /usr/bin
		echo cd /usr/share/${PN}\;java -cp /usr/share/${PN} NETIMap > "${D}"/usr/bin/NETIMap
		fperms ugo+x /usr/bin/NETIMap
	fi

	dodoc README AUTHORS
	newinitd "${FILESDIR}"/neti-init2 neti
}
