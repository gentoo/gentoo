# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2 versionator

MY_P=${PN}-$(replace_version_separator 3 -)
DESCRIPTION="JCommon is a collection of useful classes used by JFreeChart, JFreeReport and other projects"
HOMEPAGE="http://www.jfree.org/jcommon"
SRC_URI="mirror://sourceforge/jfreechart/${MY_P}.tar.gz"

LICENSE="LGPL-2"
SLOT="1.0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="
	>=virtual/jdk-1.4"
DEPEND="
	>=virtual/jdk-1.4
	test? ( dev-java/junit:4 )"

S=${WORKDIR}/${MY_P}

java_prepare() {
	find "${WORKDIR}" -name '*.jar' -print -delete || die
}

src_compile() {
	if ! use debug; then
		antflags="-Dbuild.debug=false -Dbuild.optimize=true"
	fi
	eant -f ant/build.xml compile $(use_doc) $antflags
}

src_test() {
	java-pkg_jar-from --into lib junit-4
	eant -f ant/build.xml compile-junit-tests
	ejunit4 -cp "./lib/jcommon-${PV}-junit.jar:$(java-pkg_getjars junit-4)" \
		org.jfree.junit.JCommonTestSuite
}

src_install() {
	java-pkg_newjar ${P}.jar ${PN}.jar
	dodoc README.txt
	use doc && java-pkg_dojavadoc javadoc
	use source && java-pkg_dosrc source/com source/org
}
