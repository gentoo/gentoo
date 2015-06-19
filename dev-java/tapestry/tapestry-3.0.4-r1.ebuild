# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/tapestry/tapestry-3.0.4-r1.ebuild,v 1.3 2014/08/10 20:25:37 slyfox Exp $

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="An open-source framework for creating dynamic, robust, highly scalable web applications in Java"
HOMEPAGE="http://tapestry.apache.org/"
SRC_URI="mirror://apache/${PN}/Tapestry-${PV}-src.zip"

LICENSE="Apache-2.0"
SLOT="3.0"
KEYWORDS="~amd64 ~x86"

COMMON_DEP="
	dev-java/bsf:2.3
	dev-java/commons-beanutils:1.7
	dev-java/commons-codec:0
	dev-java/commons-digester:0
	dev-java/commons-fileupload:0
	dev-java/commons-lang:2.1
	dev-java/commons-logging:0
	dev-java/jakarta-oro:2.0
	dev-java/javassist:2
	dev-java/ognl:2.6
	dev-java/servletapi:2.4"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip:0
	${COMMON_DEP}"

IUSE="${JAVA_PKG_IUSE}"

S="${WORKDIR}/Tapestry-${PV}"

EANT_GENTOO_CLASSPATH="commons-logging,commons-fileupload,commons-lang-2.1"
EANT_GENTOO_CLASSPATH+=",commons-codec,commons-beanutils-1.7,commons-digester"
EANT_GENTOO_CLASSPATH+=",servletapi-2.4,ognl-2.6,bsf-2.3,jakarta-oro-2.0"
EANT_GENTOO_CLASSPATH+=",javassist-2"
JAVA_ANT_REWRITE_CLASSPATH="true"

java_prepare() {
	mkdir config lib || die

	cp "${FILESDIR}/Version.properties" config/ || die
	cp "${FILESDIR}/build.properties" config/ || die
	cp "${FILESDIR}/common.properties" config/ || die
}

src_compile() {
	cd "${S}/framework" || die

	eant -Dgentoo.classpath="$(java-pkg_getjars ${EANT_GENTOO_CLASSPATH})"

	use doc && javadoc -sourcepath src/ org.apache.tapestry -d ../javadoc
}

src_install() {
	java-pkg_newjar "lib/${P}.jar"

	use source && java-pkg_dosrc framework/src/org
	use doc && java-pkg_dojavadoc javadoc
}
