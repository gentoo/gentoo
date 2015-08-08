# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="source"
inherit java-pkg-2 java-ant-2 java-osgi

MY_PN="${PN/lucene-}"
MY_P="${P/-${MY_PN}}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Lucene Analyzers additions"
HOMEPAGE="http://lucene.apache.org/java"
SRC_URI="mirror://apache/lucene/java/${MY_P}-src.tar.gz"
LICENSE="Apache-2.0"
SLOT="1.9"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE=""
DEPEND=">=virtual/jdk-1.4
	>=dev-java/ant-core-1.6"
RDEPEND=">=virtual/jre-1.4"

src_compile() {
	cd "${S}/contrib/${MY_PN}"
	eant
}

src_install() {
	java-osgi_newjar-fromfile "build/contrib/${MY_PN}/${PN}-1.9.2-dev.jar" \
			"${FILESDIR}/manifest" "Apache Lucene Analysis"

	use source && java-pkg_dosrc contrib/${MY_PN}/src/java/org
}
