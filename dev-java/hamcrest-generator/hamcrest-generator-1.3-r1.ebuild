# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="source test"

inherit java-pkg-2 java-ant-2

MY_PN="hamcrest"
MY_P="${MY_PN}-${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Code generator for Hamcrest's library of matchers for building test expressions"
HOMEPAGE="http://code.google.com/p/${MY_PN}/"
SRC_URI="http://${MY_PN}.googlecode.com/files/${MY_P}.tgz"

LICENSE="BSD-2"
SLOT="${PV}"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-fbsd ~ppc-macos ~x64-macos ~x86-macos"

CDEPEND=">=dev-java/qdox-1.12-r1:1.12"

DEPEND=">=virtual/jdk-1.5
	userland_GNU? ( sys-apps/findutils )
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"

EANT_BUILD_TARGET="generator"
EANT_EXTRA_ARGS="-Dversion=${PV}"

java_prepare() {
	# Don't include source in JAR.  If a Gentoo user wants the source the source
	# USE flag will be enabled.
	epatch "${FILESDIR}/${P}-no_jarjar.patch"

	find -iname "*.jar" -exec rm -v {} + || die "Unable to remove bundled JAR files"

	# These jars must be symlinked.  Specifying them using gentoo.classpath
	# does not work.
	java-pkg_jar-from --into lib/generator qdox-1.12 qdox.jar qdox-1.12.jar
}

src_install() {
	java-pkg_newjar build/${PN}-nodeps-${PV}.jar ${PN}.jar

	dodoc README.txt CHANGES.txt

	use source && java-pkg_dosrc ${PN}/src/main/java/org
}
