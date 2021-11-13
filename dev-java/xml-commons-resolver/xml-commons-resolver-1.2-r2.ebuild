# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"
JAVA_SRC_DIR="src"
MAVEN_ID="xml-resolver:xml-resolver:1.2"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="An XML Entity and URI Resolver"
HOMEPAGE="http://xml.apache.org/commons/"
SRC_URI="mirror://apache/xml/commons/${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

DOCS=( KEYS LICENSE.resolver.txt NOTICE-resolver.txt )

src_prepare() {
	default
	java-pkg_clean
	rm -rv src/org/apache/xml/resolver/tests || die
}

src_install() {
	java-pkg-simple_src_install
	einstalldocs
}
