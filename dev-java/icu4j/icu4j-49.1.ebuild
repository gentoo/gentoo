# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/icu4j/icu4j-49.1.ebuild,v 1.6 2014/08/10 20:15:08 slyfox Exp $

EAPI=4

# testdata.jar, icudata.jar and icutzdata.jar do not contain *.class files
# but *.res files. These *.res data files are needed to build the final jar.

JAVA_PKG_IUSE="doc examples source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A set of Java libraries providing Unicode and Globalization support"
HOMEPAGE="http://www.icu-project.org/"
SRC_URI="http://download.icu-project.org/files/${PN}/${PV}/${PN}-${PV//./_}.tgz"

LICENSE="icu"
SLOT="49"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

# Beware of jdk version dependant code #361593
DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}"

JAVA_PKG_BSFIX_NAME+=" common-targets.xml"

EANT_DOC_TARGET="docs"

EANT_TEST_TARGET="check"

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar "${PN}.jar"
	java-pkg_dojar "${PN}-charset.jar"
	java-pkg_dojar "${PN}-localespi.jar"

	dohtml readme.html

	use doc && java-pkg_dojavadoc doc
	use examples && java-pkg_doexamples demos samples
	use source && java-pkg_dosrc main/classes/*/src/com
}
