# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Web Services Description Language for Java Toolkit (WSDL4J)"
HOMEPAGE="https://wsdl4j.sourceforge.net"
TCK_V="1.2"
SRC_URI="mirror://sourceforge/project/wsdl4j/WSDL4J/${PV}/wsdl4j-src-${PV}.zip"

LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"
BDEPEND="app-arch/unzip"
JAVADOC_ARGS="-source 8"

S="${WORKDIR}/${P//./_}"

JAVA_SRC_DIR="src"
