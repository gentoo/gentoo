# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/guice/guice-3.0-r1.ebuild,v 1.3 2015/06/13 11:37:25 ago Exp $

EAPI="5"

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Guice is a lightweight dependency injection framework for Java 5 and above"
HOMEPAGE="http://code.google.com/p/google-guice/"
SRC_URI="http://google-guice.googlecode.com/files/${P}-src.zip"

LICENSE="Apache-2.0"
SLOT="3"
KEYWORDS="amd64 x86"

IUSE=""

COMMON_DEPEND="dev-java/aopalliance:1
	dev-java/javax-inject:0
	dev-java/asm:3
	dev-java/cglib:3"

RDEPEND=">=virtual/jre-1.6
	${COMMON_DEPEND}"

DEPEND=">=virtual/jdk-1.6
	${COMMON_DEPEND}"

RESTRICT="test"

S="${WORKDIR}/${P}-src/"

JAVA_PKG_BSFIX_NAME="build.xml common.xml servlet/build.xml"
JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_GENTOO_CLASSPATH="aopalliance-1,asm-3,cglib-3,javax-inject"

java_prepare() {
	find . -name '*.jar' -exec rm -v {} + || die
	find . -name '*.class' -exec rm -v {} + || die
	epatch "${FILESDIR}"/${PV}-common.xml.patch
	epatch "${FILESDIR}"/${PV}-build.xml.patch
}

src_install() {
	java-pkg_dojar build/${PN}.jar
	use source && java-pkg_dosrc core/src/com
}
