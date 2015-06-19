# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/dbunit/dbunit-2.4.5.ebuild,v 1.4 2015/04/21 18:35:10 pacho Exp $

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="DbUnit is a JUnit extension targeted for database-driven projects"
HOMEPAGE="http://dbunit.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-sources.jar"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86"

IUSE="${JAVA_PKG_IUSE}"

COMMON_DEP="dev-java/slf4j-api:0
			dev-java/poi:3.2
			dev-java/commons-collections:0
			dev-java/ant-core:0
			dev-java/junit:0"

RDEPEND=">=virtual/jre-1.4
	dev-java/slf4j-nop:0
	${COMMON_DEP}"

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip:0
	${COMMON_DEP}"

S="${WORKDIR}"

java_prepare() {
	# Upstream no longer provides a build file.
	cp -v "${FILESDIR}"/build-2.4.xml build.xml || die
}

EANT_GENTOO_CLASSPATH="poi-3.2,junit,slf4j-api,commons-collections,ant-core"
JAVA_ANT_REWRITE_CLASSPATH="true"

src_install() {
	# slf4j needed for runtime
	java-pkg_register-optional-dependency slf4j-nop
	java-pkg_register-optional-dependency slf4j-log4j12

	java-pkg_dojar "${S}"/dist/"${PN}.jar"

	use doc && java-pkg_dojavadoc build/javadoc
	use source && java-pkg_dosrc org
}
