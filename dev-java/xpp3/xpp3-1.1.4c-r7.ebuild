# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="xpp3:xpp3:1.1.4c"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="An implementation of XMLPULL V1 API"
HOMEPAGE="https://www.extreme.indiana.edu/xgws/xsoap/xpp/mxp1/index.html"
SRC_URI="https://repo1.maven.org/maven2/${PN}/${PN}/${PV}/${P}-sources.jar -> ${P}.jar"

LICENSE="Apache-1.1 IBM JDOM LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

PATCHES=( "${FILESDIR}/xpp3-1.1.4c-namespace.patch" )

JAVA_RESOURCE_DIRS="resources"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
	mkdir "resources" || die
	cp -r "META-INF" "resources" || die
}
