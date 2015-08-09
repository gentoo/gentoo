# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Extensions to complement JSR-173 StAX API"
HOMEPAGE="http://stax-ex.java.net/"
SRC_URI="https://stax-ex.java.net/files/documents/4480/44372/${P}-src.tar.gz"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"

IUSE=""

COMMON_DEPEND="java-virtuals/jaf:0
	java-virtuals/stax-api:0"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPEND}"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEPEND}"

JAVA_GENTOO_CLASSPATH="jaf,stax-api"

S="${WORKDIR}/${P}"

src_prepare() {
	rm "${S}"/build.xml || die
}
