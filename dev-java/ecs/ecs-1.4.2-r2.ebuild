# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java library to generate markup language text such as HTML and XML"
HOMEPAGE="http://jakarta.apache.org/ecs"
SRC_URI="mirror://apache/jakarta/${PN}/source/${P}-src.tar.gz"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

CDEPEND="
	dev-java/xerces:2
	dev-java/jakarta-regexp:1.3"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	source? ( app-arch/zip )
	>=virtual/jdk-1.6"

S="${WORKDIR}/${P}-src"

JAVA_ENCODING="ISO8859-1"
JAVA_SRC_DIR="src/java"

JAVA_GENTOO_CLASSPATH="xerces-2,jakarta-regexp-1.3"

java_prepare() {
	java-pkg_clean
	epatch "${FILESDIR}"/${P}-java7-enum.patch
}
