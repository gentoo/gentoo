# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-el/commons-el-1.0-r3.ebuild,v 1.6 2014/08/10 20:10:37 slyfox Exp $

EAPI=5

JAVA_PKG_IUSE="source"

inherit eutils java-pkg-2 java-ant-2 java-osgi

DESCRIPTION="EL is the JSP 2.0 Expression Language Interpreter from Apache"
HOMEPAGE="http://commons.apache.org/el/"
SRC_URI="mirror://apache/jakarta/commons/el/source/${P}-src.tar.gz"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd"
IUSE=""

COMMON_DEP="
	java-virtuals/servlet-api:2.5"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.4"
DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.4"

S=${WORKDIR}/${P}-src

JAVA_PKG_FILTER_COMPILER="jikes"

java_prepare() {
	epatch "${FILESDIR}"/${P}-java-1.7-compiler.patch # BGO 486376
	# Build.xml is broken, fix it
	sed -i "s:../LICENSE:./LICENSE.txt:" build.xml || die "sed failed"
}

JAVA_ANT_REWRITE_CLASSPATH="yes"

EANT_GENTOO_CLASSPATH="servlet-api-2.5"
EANT_EXTRA_ARGS="
	-Dservletapi.build.notrequired=true
	-Djspapi.build.notrequired=true"

src_install() {
	java-osgi_dojar-fromfile "dist/${PN}.jar" "${FILESDIR}/${P}-manifest" \
		"Apache Commons EL"

	dodoc LICENSE.txt RELEASE-NOTES.txt
	dohtml STATUS.html PROPOSAL.html

	use source && java-pkg_dosrc src/java/org
}
