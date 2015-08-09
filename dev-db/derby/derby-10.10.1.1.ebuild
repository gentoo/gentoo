# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source test"
JAVA_PKG_BSFIX="off"

inherit java-pkg-2 java-ant-2

MY_P=db-${P}
DESCRIPTION="An embeddable relational database implemented entirely in Java"
HOMEPAGE="http://db.apache.org/derby/"
SRC_URI="mirror://apache/db/${PN}/${MY_P}/${MY_P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="linguas_de linguas_es linguas_fr linguas_hu linguas_it linguas_ja linguas_ko linguas_pl linguas_pt linguas_ru linguas_zh"

LANGS="de es fr hu it ja ko pl pt ru zh"

# see https://issues.apache.org/jira/browse/DERBY-5125
DEPEND=">=virtual/jdk-1.6
	<dev-java/javacc-4.2:0
	test? ( dev-java/jakarta-oro:2.0 )
	"
RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

S="${WORKDIR}/${MY_P}-src"

EANT_BUILD_TARGET="buildsource buildjars"
EANT_TEST_TARGET="testing"

java_prepare() {
	find tools/java -name "*.jar" -exec rm -v {} \; || die
	cd tools/java || die

	java-pkg_jar-from --build-only javacc
	use test && java-pkg_jar-from --build-only jakarta-oro:2.0 jakarta-oro.jar jakarta-oro-2.0.8.jar
}

src_install() {
	strip-linguas ${LANGS}
	local LOCALE_JARS="${LINGUAS// /,}"

	java-pkg_dojar jars/sane/derby{,run,net,tools,client}.jar

	for x in ${LINGUAS}; do
		java-pkg_dojar jars/sane/derbyLocale_${x}*.jar
	done

	java-pkg_dowar jars/sane/derby.war

	dodoc README STATUS KEYS NOTICE || die "docs failed"
	dohtml -r {RELEASE-NOTES,published_api_overview}.html || die "docs failed"

	use doc && java-pkg_dojavadoc javadoc
	use source && java-pkg_dosrc java/
}

src_test() {
	java-pkg-2_src_test
}
