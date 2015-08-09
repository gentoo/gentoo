# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A text-processing Java classes that serialize objects to XML and back again"
HOMEPAGE="http://xstream.codehaus.org/index.html"
SRC_URI="http://repository.codehaus.org/com/thoughtworks/${PN}/${PN}-distribution/${PV}/${PN}-distribution-${PV}-src.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"

# By default, these tests exit successfully on failure. Chewi has fixed
# that below but it's probably because they blow up spectacularly on
# every VM he has tried.
RESTRICT="test"

CDEPEND="dev-java/cglib:3
	dev-java/dom4j:1
	dev-java/jdom:1.0
	dev-java/joda-time:0
	dev-java/xom:0
	dev-java/xpp3:0
	dev-java/xml-commons-external:1.3
	dev-java/jettison:0
	java-virtuals/stax-api:0"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	test? (
		dev-java/ant-junit:0
		dev-java/ant-trax:0
		dev-java/junit:4
		dev-java/xml-writer:0
		dev-java/commons-lang:2.1
		dev-java/jmock:1.0
		dev-java/jakarta-oro:2.0
		dev-java/stax:0
		dev-java/wstx:3.2
	)
	${CDEPEND}"

S="${WORKDIR}/${P}/${PN}"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="xpp3,jdom-1.0,xom,dom4j-1,joda-time,cglib-3,xml-commons-external-1.3,jettison,stax-api"
EANT_BUILD_TARGET="benchmark:compile jar"
EANT_EXTRA_ARGS="-Dversion=${PV} -Djunit.haltonfailure=true"

java_prepare() {
	rm -v lib/*.jar || die
	rm -rfv lib/jdk1.3 || die
}

EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},junit-4,jmock-1.0,commons-lang-2.1,xml-writer,wstx-3.2,stax,jakarta-oro-2.0"
EANT_TEST_TARGET="test"
ANT_TASKS="ant-junit ant-trax"

src_test() {
	java-pkg-2_src_test
}

src_install(){
	java-pkg_newjar target/${P}.jar
	java-pkg_newjar target/${PN}-benchmark-${PV}.jar ${PN}-benchmark.jar

	use doc && java-pkg_dojavadoc target/javadoc
	use source && java-pkg_dosrc src/java/com
}

pkg_postinst(){
	elog "Major Changes from 1.2 See:"
	elog "http://xstream.codehaus.org/changes.html"
	elog "to prevent breakage ..."
}
