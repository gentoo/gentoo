# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_P="${PN}-jdk15-${PV/./}"
DESCRIPTION="Java cryptography APIs"
HOMEPAGE="http://www.bouncycastle.org/java.html"
SRC_URI="http://www.bouncycastle.org/download/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="1.45"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"

CDEPEND="
	dev-java/bcprov:${SLOT}
	dev-java/junit:0
	dev-java/sun-jaf:0
	dev-java/oracle-javamail:0
"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	${CDEPEND}"
RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"
IUSE=""

S="${WORKDIR}/${MY_P}"

JAVA_GENTOO_CLASSPATH="
	junit
	sun-jaf
	bcprov-${SLOT}
	oracle-javamail
"

src_unpack() {
	default
	cd "${S}"
	unpack ./src.zip
}

src_compile() {
	java-pkg-simple_src_compile
}

src_install() {
	java-pkg-simple_src_install
	use source && java-pkg_dosrc org
}
