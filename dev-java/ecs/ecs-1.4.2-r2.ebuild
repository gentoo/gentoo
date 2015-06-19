# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ecs/ecs-1.4.2-r2.ebuild,v 1.3 2015/03/27 10:28:35 ago Exp $

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-pkg-simple

DESCRIPTION="Java library to generate markup language text such as HTML and XML"
HOMEPAGE="http://jakarta.apache.org/ecs"
SRC_URI="mirror://apache/jakarta/${PN}/source/${P}-src.tar.gz"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

CDEPEND="dev-java/jakarta-regexp:1.3
	dev-java/xerces:2"

RDEPEND=">=virtual/jre-1.4
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.4
	${CDEPEND}"

S="${WORKDIR}/${P}-src"

JAVA_ENCODING="iso8859-1"
JAVA_SRC_DIR="src/java"
JAVA_GENTOO_CLASSPATH="xerces-2,jakarta-regexp-1.3"

java_prepare() {
	find "${S}" -name "*.jar" -delete || die
	epatch "${FILESDIR}"/${PV}*.patch
}
