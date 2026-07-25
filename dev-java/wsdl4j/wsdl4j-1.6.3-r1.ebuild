# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Web Services Description Language for Java Toolkit (WSDL4J)"
HOMEPAGE="https://wsdl4j.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/project/wsdl4j/WSDL4J/${PV}/wsdl4j-src-${PV}.zip"
S="${WORKDIR}/${P//./_}"

LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

BDEPEND="app-arch/unzip"
DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"
JAVADOC_ARGS="-source 8"

# There was a compilation error in dev-java/bcel-6.11.0:
# Error: Modules wsdl4j and java.xml export package javax.xml.namespace
# to module org.eclipse.jdt.core.compiler.batch
# The jar provided upstream does not package javax/xml.
JAVA_SRC_DIR=( -type f ! -path '*/javax/xml/*' -name '*.java' )

src_install() {
	JAVA_SRC_DIR=( src )
	java-pkg-simple_src_install
}
