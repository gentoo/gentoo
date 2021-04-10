# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/jaxen-xpath/jaxen/archive/refs/tags/v1.2.0.tar.gz --slot 1.2 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild jaxen-1.2.0.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="jaxen:jaxen:1.2.0"
JAVA_TESTING_FRAMEWORKS="junit"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jaxen is a universal XPath engine for Java."
HOMEPAGE="http://www.cafeconleche.org/jaxen/"
SRC_URI="https://github.com/${PN}-xpath/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="1.2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

# It seems that most tests depend on dom4j, jdom and xom which all depend on jaxen
RESTRICT="test"

# Compile dependencies
# POM: pom.xml
# xerces:xercesImpl:2.6.2 -> >=dev-java/xerces-2.12.0:2
# xml-apis:xml-apis:1.3.02 -> >=dev-java/xml-commons-external-1.4.01:1.4
# POM: pom.xml
# test? junit:junit:3.8.2 -> >=dev-java/junit-3.8.2:0

DEPEND="
	>=virtual/jdk-1.8:*
	${CDEPEND}
	>=dev-java/xerces-2.12.0:2
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CDEPEND}
"

S="${WORKDIR}"

DOCS=( "${P}"/{LICENSE.txt,README.md} )

JAVA_CLASSPATH_EXTRA="xerces-2"
JAVA_SRC_DIR="${P}/src/java/main"

src_prepare() {
	default

	# solve cyclic deps by removing these dirs
	# dom4j, jdom and xom depend on jaxen
	# https://bugs.gentoo.org/739894#c9
	rm -rv "${JAVA_SRC_DIR}"/org/jaxen/{dom4j,jdom,xom} || die
}

src_install() {
	default
	java-pkg-simple_src_install
}
