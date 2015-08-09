# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc examples source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A set of Java libraries providing Unicode and Globalization support"
HOMEPAGE="http://www.icu-project.org/"
SRC_URI="http://download.icu-project.org/files/${PN}/${PV}/${PN}-${PV//./_}.tgz"

LICENSE="icu"
SLOT="55"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

# Beware of jdk version dependant code #361593
DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}"

JAVA_PKG_BSFIX_NAME+=" common-targets.xml"

EANT_DOC_TARGET="docs"
EANT_TEST_TARGET="check"

JAVA_RM_FILES=(
	tools/build/src/com/ibm/icu/dev/tool/docs/ICUTaglet.java
)

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar ${PN}.jar
	java-pkg_dojar ${PN}-charset.jar
	java-pkg_dojar ${PN}-localespi.jar

	dohtml readme.html

	use doc && java-pkg_dojavadoc doc
	use examples && java-pkg_doexamples demos samples
	use source && java-pkg_dosrc main/classes/*/src/com
}
