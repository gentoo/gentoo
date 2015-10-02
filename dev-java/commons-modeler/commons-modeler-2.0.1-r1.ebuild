# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="doc source test"
inherit java-pkg-2 java-ant-2

DESCRIPTION="A lib to make the setup of Java Management Extensions easier"
SRC_URI="mirror://apache/commons/modeler/source/${P}-src.tar.gz"
HOMEPAGE="http://commons.apache.org/modeler/"
LICENSE="Apache-2.0"
SLOT="0"

# Provides ant tasks for ant to use
RDEPEND=">=virtual/jre-1.5
	dev-java/mx4j-core:3.0
	dev-java/commons-logging:0
	commons-digester? ( dev-java/commons-digester:3.2 )"
DEPEND=">=virtual/jdk-1.6
	source? ( app-arch/zip )
	test? ( dev-java/junit:0 )"

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="commons-digester"

S=${WORKDIR}/${P}-src

java_prepare() {
	# Setup the build environment
	use commons-digester && echo "commons-digester.jar=$(java-pkg_getjar commons-digester-3.2 commons-digester.jar)" >> build.properties
	echo "commons-logging.jar=$(java-pkg_getjar commons-logging commons-logging.jar)" >> build.properties
	echo "jmx.jar=$(java-pkg_getjar mx4j-core-3.0 mx4j.jar)" >> build.properties

	mkdir dist || die
}

EANT_BUILD_TARGET="prepare jar"

src_test() {
	eant test -Djunit.jar=$(java-pkg_getjar --build-only junit junit.jar)
}

src_install() {
	java-pkg_dojar dist/${PN}.jar
	dodoc RELEASE-NOTES.txt || die
	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/java/org
}
