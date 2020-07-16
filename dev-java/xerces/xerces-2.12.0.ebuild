# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_PN="xercesImpl"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Xerces Java XML parser"
HOMEPAGE="https://xml.apache.org/xerces2-j/index.html"
SRC_URI="https://repo1.maven.org/maven2/xerces/${MY_PN}/${PV}/${MY_P}-sources.jar -> ${P}.jar"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

CDEPEND="
	dev-java/xjavac:1
	dev-java/xml-commons-resolver:0
	dev-java/xml-commons-external:1.4"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

JAVA_SRC_DIR="org"

JAVA_GENTOO_CLASSPATH="
	xjavac-1
	xml-commons-resolver
	xml-commons-external-1.4"

S="${WORKDIR}"

src_prepare() {
	default

	epatch "${FILESDIR}/${P}-overrides.patch"
}
