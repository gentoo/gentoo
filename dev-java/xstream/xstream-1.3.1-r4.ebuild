# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A text-processing Java classes that serialize objects to XML and back again"
HOMEPAGE="http://x-stream.github.io"
SRC_URI="http://repo.maven.apache.org/maven2/com/thoughtworks/${PN}/${PN}-distribution/${PV}/${PN}-distribution-${PV}-src.zip"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"

# By default, these tests exit successfully on failure. Chewi has fixed
# that below but it's probably because they blow up spectacularly on
# every VM he has tried. They also depend on classes unique to the
# Codehaus StAX implementation (dev-java/stax), which has now been
# last-rited, so we no longer bother to support them at all.
RESTRICT="test"

CDEPEND="
	dev-java/xom:0
	dev-java/jdom:0
	dev-java/xpp3:0
	dev-java/cglib:3
	dev-java/dom4j:1
	dev-java/jettison:0
	dev-java/joda-time:0
	dev-java/xml-commons-external:1.3"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	app-arch/unzip
	>=virtual/jdk-1.6"

S="${WORKDIR}/${P}/${PN}"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="xpp3,jdom,xom,dom4j-1,joda-time,cglib-3,xml-commons-external-1.3,jettison"
EANT_BUILD_TARGET="benchmark:compile jar"
EANT_EXTRA_ARGS="-Dversion=${PV} -Djunit.haltonfailure=true"

java_prepare() {
	rm -v lib/*.jar || die
	rm -rfv lib/jdk1.3 || die
}

src_install() {
	java-pkg_newjar "target/${P}.jar"
	java-pkg_newjar "target/${PN}-benchmark-${PV}.jar" "${PN}-benchmark.jar"

	use doc && java-pkg_dojavadoc target/javadoc
	use source && java-pkg_dosrc src/java/com
}
