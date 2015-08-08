# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="source"
inherit java-pkg-2 java-ant-2 java-osgi

MY_PN="${PN/lucene-}"
MY_P="${P/-${MY_PN}}"

DESCRIPTION="Lucene Analyzers additions"
HOMEPAGE="http://lucene.apache.org/java"
SRC_URI="mirror://apache/lucene/java/${MY_P}-src.tar.gz"
LICENSE="Apache-2.0"
SLOT="2.3"
KEYWORDS="amd64 ppc x86 ~x86-fbsd ~x86-linux ~amd64-linux ~ppc-macos"
IUSE=""
DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}/${MY_P}/contrib/${MY_PN}"

src_install() {
	java-osgi_newjar-fromfile "${WORKDIR}/${MY_P}/build/contrib/${MY_PN}/${PN}-${SLOT}.jar" \
			"${FILESDIR}/manifest" "Apache Lucene Analysis"

	use source && java-pkg_dosrc "${S}/src/java/org"
}
