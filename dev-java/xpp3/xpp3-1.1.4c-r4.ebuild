# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"
MAVEN_ID="xpp3:xpp3:1.1.4c"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="An implementation of XMLPULL V1 API"
HOMEPAGE="http://www.extreme.indiana.edu/xgws/xsoap/xpp/mxp1/index.html"
SRC_URI="https://repo1.maven.org/maven2/${PN}/${PN}/${PV}/${P}-sources.jar -> ${P}.jar"

LICENSE="Apache-1.1 IBM JDOM LGPL-2.1+"
SLOT="0"

KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6"
