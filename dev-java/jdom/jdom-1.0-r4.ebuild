# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java API to manipulate XML data"
SRC_URI="http://www.jdom.org/dist/source/archive/${P}.tar.gz"
HOMEPAGE="http://www.jdom.org"
LICENSE="JDOM"
SLOT="${PV}"
KEYWORDS="amd64 ~arm ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
COMMON_DEP="dev-java/saxpath
		>=dev-java/xerces-2.7"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}"
PDEPEND="~dev-java/jdom-jaxen-${PV}"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	rm -v build/*.jar lib/*.jar || die
	rm -rf build/{apidocs,samples} || die

	rm -v src/java/org/jdom/xpath/JaxenXPath.java \
		|| die "Unable to remove Jaxen Binding class."

	cd "${S}"/lib
	java-pkg_jar-from saxpath,xerces-2
}

src_compile() {
	# to prevent a newer jdom from going into cp
	# (EANT_ANT_TASKS doesn't work with none)
	ANT_TASKS="none" eant package $(use_doc)
}

src_install() {
	java-pkg_dojar build/*.jar

	java-pkg_register-dependency "jdom-jaxen-${SLOT}"

	dodoc CHANGES.txt COMMITTERS.txt README.txt TODO.txt || die
	use doc && java-pkg_dojavadoc build/apidocs
	use examples && java-pkg_doexamples samples
	use source && java-pkg_dosrc src/java/org
}
