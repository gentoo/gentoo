# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/odfdom/odfdom-0.8.6-r1.ebuild,v 1.2 2014/08/10 20:22:01 slyfox Exp $

EAPI="4"

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="The ODFDOM reference implementation, written in Java"
HOMEPAGE="http://odftoolkit.org/projects/odfdom"
SRC_URI="http://odftoolkit.org/projects/odfdom/downloads/download/current-version%252F${P}-sources.zip -> ${P}-sources.zip"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc-aix ~hppa-hpux ~ia64-hpux ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE=""

CDEPEND="dev-java/xerces:2
	dev-java/xml-commons-external:1.4"

RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.5
	${CDEPEND}
	test? (
		dev-java/ant-junit4:0
		dev-java/hamcrest-core:0
		dev-java/junit:4
	)"

S="${WORKDIR}/${P}-sources"

EANT_GENTOO_CLASSPATH="xerces-2,xml-commons-external-1.4"
JAVA_ANT_REWRITE_CLASSPATH="yes"

src_prepare() {
	cp "${FILESDIR}/build-${PV}.xml" build.xml || die

	mkdir lib || die
}

EANT_BUILD_TARGET="package"
EANT_JAVADOC_TARGET="javadoc"
EANT_EXTRA_ARGS="-Dmaven.test.skip=true"
EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},hamcrest-core,junit-4"

src_test() {
	EANT_EXTRA_ARGS="" \
		java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar target/odfdom.jar

	dodoc README.txt LICENSE.txt || die
	use doc && java-pkg_dojavadoc target/site/apidocs
}
