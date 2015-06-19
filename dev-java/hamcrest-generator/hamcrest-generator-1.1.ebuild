# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/hamcrest-generator/hamcrest-generator-1.1.ebuild,v 1.1 2014/02/28 17:34:39 ercpe Exp $

EAPI="5"

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

MY_PN="hamcrest"
MY_P="${MY_PN}-${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Code generator for Hamcrest's library of matchers for building test expressions"
HOMEPAGE="http://code.google.com/p/${MY_PN}/"
SRC_URI="http://${MY_PN}.googlecode.com/files/${MY_P}.tgz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86 ~amd64-fbsd"

CDEPEND="dev-java/qdox:1.6"

DEPEND=">=virtual/jdk-1.5
	userland_GNU? ( sys-apps/findutils )
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"

EANT_BUILD_TARGET="generator"
EANT_TEST_TARGET="unit-test"
EANT_EXTRA_ARGS="-Dversion=${PV}"
EANT_GENTOO_CLASSPATH_EXTRA="${S}/build/temp/${PN}-${PV}-nodeps.jar"

java_prepare() {
	epatch "${FILESDIR}"/${PV}-build.xml.patch

	find -iname "*.jar" -exec rm -v {} + || die "Unable to remove bundled JAR files"

	# These jars must be symlinked.  Specifying them using gentoo.classpath
	# does not work.
	java-pkg_jar-from --into lib/generator qdox-1.6 qdox.jar qdox-1.6.1.jar
}

src_install() {
	java-pkg_newjar build/temp/${PN}-${PV}-nodeps.jar ${PN}.jar

	dodoc README.txt CHANGES.txt

	use source && java-pkg_dosrc ${PN}/src/main/java/org
}
