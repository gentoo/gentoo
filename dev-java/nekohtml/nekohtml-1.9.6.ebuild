# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/nekohtml/nekohtml-1.9.6.ebuild,v 1.7 2014/08/10 20:21:47 slyfox Exp $

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="A simple HTML scanner and tag balancer using standard XML interfaces"

HOMEPAGE="http://nekohtml.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="Apache-2.0"

SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

COMMON_DEP=">=dev-java/xerces-2.7"
DEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"

JAVA_ANT_CLASSPATH_TAGS="${JAVA_ANT_CLASSPATH_TAGS} taskdef"

src_unpack() {
	unpack ${A}
	cd "${S}"
	java-ant_rewrite-classpath
	rm -v lib/*.jar *.jar || die
	java-pkg_jar-from --into lib xerces-2
}

EANT_DOC_TARGET=""

src_test() {
	EANT_GENTOO_CLASSPATH="ant-core,xerces-2" eant test
}

src_install() {
	java-pkg_dojar build/lib/${PN}.jar

	if use doc; then
		java-pkg_dojavadoc --symlink javadoc doc/javadoc
		dohtml doc/*
	fi

	use source && java-pkg_dosrc ./src/org
	use examples && java-pkg_doexamples src/sample
}
