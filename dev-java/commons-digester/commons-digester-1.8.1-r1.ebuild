# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-digester/commons-digester-1.8.1-r1.ebuild,v 1.6 2014/08/10 20:10:27 slyfox Exp $

EAPI=2
JAVA_PKG_IUSE="doc examples source test"

inherit eutils java-pkg-2 java-ant-2

MY_P="${P}-src"
DESCRIPTION="Reads XML configuration files to provide initialization of various Java objects within the system"
HOMEPAGE="http://commons.apache.org/digester/"
SRC_URI="mirror://apache/commons/digester/source/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=virtual/jre-1.4
	dev-java/commons-beanutils:1.7
	>=dev-java/commons-collections-2.1:0
	>=dev-java/commons-logging-1.0.2:0"
DEPEND=">=virtual/jdk-1.4
	test? (
		dev-java/junit:0
		dev-java/ant-junit
	)
	${RDEPEND}"

S="${WORKDIR}/${P}-src"

# don't rewrite build.xml in examples
JAVA_PKG_BSFIX_ALL="no"

java_prepare() {
	epatch "${FILESDIR}/${PV}-build.xml-jar-target.patch"

	# this build.xml honours build.properties so we use it for common depends
	# needed for both compile and test, so getjar is called only once
	echo "commons-beanutils.jar=$(java-pkg_getjar commons-beanutils-1.7 \
		commons-beanutils.jar)" > build.properties
	echo "commons-collections.jar=$(java-pkg_getjar commons-collections \
		commons-collections.jar)" >> build.properties
	echo "commons-logging.jar=$(java-pkg_getjar commons-logging \
		commons-logging.jar)" >> build.properties
}

src_test() {
	ANT_TASKS="ant-junit" eant \
		-Djunit.jar="$(java-pkg_getjar --build-only junit junit.jar)" test
}

src_install() {
	java-pkg_dojar "dist/${PN}.jar"

	dodoc RELEASE-NOTES.txt || die

	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/java/org
	use examples && java-pkg_doexamples src/examples
}
