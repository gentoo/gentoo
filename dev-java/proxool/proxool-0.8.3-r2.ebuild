# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/proxool/proxool-0.8.3-r2.ebuild,v 1.4 2014/08/10 20:22:39 slyfox Exp $

EAPI=4

JAVA_PKG_IUSE="doc source"
WANT_ANT_TASKS="ant-nodeps"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Proxool is a Java connection pool"
HOMEPAGE="http://proxool.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-source.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

# Tests disabled because they would need hibernate
# and as such creating a circular dependency
RESTRICT="test"

COMMON_DEP="
	dev-java/avalon-framework:4.2
	dev-java/avalon-logkit:2.0
	dev-java/log4j:0
	dev-java/mx4j-core:3.0
	java-virtuals/servlet-api:3.0"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.4"
# Require jdk6 for building. #402487
DEPEND="${COMMON_DEP}
	virtual/jdk:1.6
	dev-util/checkstyle:0"

java_prepare() {
	find -name '*.jar' -exec rm {} + || die

	java-pkg_jar-from --into lib --build-only checkstyle
}

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_BUILD_TARGET="build-jar"
EANT_GENTOO_CLASSPATH="log4j,servlet-api-3.0,avalon-framework-4.2,avalon-logkit-2.0,mx4j-core-3.0"

src_install() {
	java-pkg_newjar build/${P}.jar ${PN}.jar

	dodoc README.txt || die
	# dohtml valid as there are other docs too
	use doc && java-pkg_dohtml -r doc/*
	use source && java-pkg_dosrc src/java/*
}
