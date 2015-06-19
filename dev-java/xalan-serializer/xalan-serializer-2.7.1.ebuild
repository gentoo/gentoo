# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/xalan-serializer/xalan-serializer-2.7.1.ebuild,v 1.11 2013/06/14 19:35:24 aballier Exp $

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2 eutils versionator

MY_PN="xalan-j"
MY_PV="$(replace_all_version_separators _)"
MY_P="${MY_PN}_${MY_PV}"
DESCRIPTION="DOM Level 3 serializer from Apache Xalan, shared by Xalan and Xerces"
HOMEPAGE="http://xml.apache.org/xalan-j/index.html"
SRC_URI="mirror://apache/xml/${MY_PN}/source/${MY_P}-src.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

COMMON_DEP="=dev-java/xml-commons-external-1.3*"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# kill all non-serializer sources to ease javadocs and dosrc
	cd src/org/apache || die
	mv xml/serializer "${T}/" || die "failed to mv to temp"
	rm -rf ./* || die
	mkdir xml || die
	mv "${T}/serializer" xml/ || die "failed to mv from temp"

	# kill bundled jars and packed xml-commons-external sources
	cd "${S}"
	rm -v lib/*.jar tools/*.jar src/*.tar.gz || die

	cd lib
	java-pkg_jar-from xml-commons-external-1.3 xml-apis.jar
}

EANT_BUILD_TARGET="serializer.jar"
EANT_DOC_TARGET="serializer.javadocs"

src_install() {
	java-pkg_dojar build/serializer.jar

	use doc && java-pkg_dojavadoc build/docs/apidocs
	use source && java-pkg_dosrc src/org
}
