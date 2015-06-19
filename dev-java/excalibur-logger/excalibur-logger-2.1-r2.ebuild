# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/excalibur-logger/excalibur-logger-2.1-r2.ebuild,v 1.3 2009/07/05 20:01:44 maekke Exp $

EAPI="2"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Logger from the Excalibur containerkit"
HOMEPAGE="http://excalibur.apache.org/containerkit.html"
SRC_URI="mirror://apache/${PN//-logger}/${PN}/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE=""

# Needs 2.1 of avalon-logkit
# which does not have the jms and javamail use flags
# that are needed for this package to build
CDEP="
	dev-java/avalon-logkit:2.0
	dev-java/avalon-framework:4.2
	dev-java/log4j:0
	dev-java/servletapi:2.4
	java-virtuals/javamail
	java-virtuals/jms"

RDEPEND=">=virtual/jre-1.4
	${CDEP}"

DEPEND=">=virtual/jdk-1.4
		${CDEP}"

java_prepare() {
	mkdir -p target/lib
	cd target/lib
	java-pkg_jar-from avalon-logkit-2.0
	java-pkg_jar-from avalon-framework-4.2
	java-pkg_jar-from log4j
	java-pkg_jar-from servletapi-2.4
	java-pkg_jar-from --virtual javamail
	java-pkg_jar-from --virtual jms
}

src_install() {
	java-pkg_newjar target/${P}.jar
	dodoc NOTICE.txt || die
	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/java/*
}
