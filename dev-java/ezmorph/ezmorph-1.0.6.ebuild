# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A simple Java library for transforming an Object to another Object"
HOMEPAGE="http://ezmorph.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-sources.jar"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMMON_DEP="dev-java/commons-lang:2.1
	dev-java/commons-beanutils:1.7
	dev-java/commons-logging:0"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${COMMON_DEP}"

JAVA_GENTOO_CLASSPATH="
	commons-lang-2.1
	commons-beanutils-1.7
	commons-logging"

RESTRICT=test #564158

java_prepare() {
	# Don't build tests all the time
	if ! use test ; then
		rm -r net/sf/ezmorph/test || die
	fi
}

src_install() {
	java-pkg_dojar ${PN}.jar
	use doc && java-pkg_dojavadoc target/api
	use source && java-pkg_dosrc net
}
