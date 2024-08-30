# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java API to manipulate XML data"
HOMEPAGE="http://jdom.org"
SRC_URI="http://jdom.org/dist/binary/archive/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="JDOM"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

DOCS=( {CHANGES,COMMITTERS,README,TODO}.txt )

JAVA_SRC_DIR="src"

src_prepare() {
	java-pkg-2_src_prepare
	java-pkg_clean

	# circular dependency with jaxen-1.2[jdom]
	rm -v src/java/org/jdom/xpath/JaxenXPath.java \
		|| die "Unable to remove Jaxen Binding class."
}

src_install() {
	java-pkg-simple_src_install
	use examples && java-pkg_doexamples samples
}
