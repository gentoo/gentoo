# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="xml-resolver:xml-resolver:1.2"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="An XML Entity and URI Resolver"
HOMEPAGE="https://xerces.apache.org/xml-commons/components/resolver/"
SRC_URI="mirror://apache/xerces/xml-commons/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

DOCS=( KEYS LICENSE.resolver.txt NOTICE-resolver.txt )
HTML_DOCS=( docs/resolver{,-release-notes}.html )

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src"
JAVA_RESOURCE_DIRS="resources"
JAVA_MAIN_CLASS="org.apache.xml.resolver.apps.resolver"

src_prepare() {
	default
	java-pkg_clean
	rm -rv src/org/apache/xml/resolver/tests || die
	mkdir -p resources/org/apache/xml/resolver || die
	mv etc resources/org/apache/xml/resolver || die
}

src_install() {
	default
	java-pkg-simple_src_install
}
