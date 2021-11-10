# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom dom4j-2.1.3.pom --download-uri https://github.com/dom4j/dom4j/archive/refs/tags/version-2.1.3.tar.gz --slot 1 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild dom4j-2.1.3.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.dom4j:dom4j:2.1.3"
JAVA_TESTING_FRAMEWORKS="testng"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="flexible XML framework for Java"
HOMEPAGE="https://dom4j.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/version-${PV}.tar.gz -> ${P}.tar.gz
	https://repo1.maven.org/maven2/jaxen/jaxen/1.2.0/jaxen-1.2.0.jar"

LICENSE="dom4j"
SLOT="1"
KEYWORDS="amd64 ~arm64 ~ppc64 x86"
IUSE="jaxen"

CDEPEND="
	dev-java/jaxb-api:2
	dev-java/xpp2:0
	dev-java/xpp3:0
	dev-java/xsdlib:0
	jaxen? ( dev-java/jaxen:1.2[dom4j] )
"
DEPEND="${CDEPEND}
	>=virtual/jdk-1.8:*
	test? ( dev-java/xerces:2 )
"

# Runtime dependencies
# POM: ${P}.pom
# javax.xml.bind:jaxb-api:2.2.12 -> !!!groupId-not-found!!!
# javax.xml.stream:stax-api:1.0-2 -> java-virtuals/stax-api:0
# jaxen:jaxen:1.1.6 -> >=dev-java/jaxen-1.2.0:1.2
# net.java.dev.msv:xsdlib:2013.6.1 -> >=dev-java/xsdlib-20090415:0
# pull-parser:pull-parser:2 -> >=dev-java/xpp2-2.1.10:0
# xpp3:xpp3:1.1.4c -> >=dev-java/xpp3-1.1.4c:0

RDEPEND="${CDEPEND}
	>=virtual/jre-1.8:*
"

PATCHES=(
	# XmlStartTag.java:31: error: ProxyXmlStartTag is not abstract and does not override abstract method removeAttributeByRawName
	# patch from https://github.com/dom4j/dom4j/pull/22
	"${FILESDIR}"/dom4j-2.1.3-xpp3-add-removeAttribute.patch
)

S="${WORKDIR}/${PN}-version-${PV}"

# dom4j has a cyclic dependency on jaxen[dom4j].
# The downloaded jaxen-1.2.0.jar is provided for compilation only.
# No prebuilt software is actually installed onto the system.
JAVA_GENTOO_CLASSPATH_EXTRA="${DISTDIR}/jaxen-1.2.0.jar"
JAVA_GENTOO_CLASSPATH="jaxb-api-2,xpp2,xpp3,xsdlib"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="testng,xerces-2"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="xml"

src_prepare() {
	default

	if use jaxen; then
		JAVA_GENTOO_CLASSPATH+=" jaxen-1.2"
	fi
}
