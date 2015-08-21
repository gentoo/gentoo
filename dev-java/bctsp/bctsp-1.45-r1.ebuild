# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_P="${PN}-jdk15-${PV/./}"
DESCRIPTION="Java cryptography APIs"
HOMEPAGE="http://www.bouncycastle.org/java.html"
SRC_URI="http://www.bouncycastle.org/download/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

CDEPEND="dev-java/bcprov:1.45
	dev-java/bcmail:1.45"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.6
	app-arch/unzip"

S="${WORKDIR}"/${MY_P}

JAVA_GENTOO_CLASSPATH="bcprov-1.45,bcmail-1.45"

src_unpack() {
	default
	cd "${S}" || die
	unpack ./src.zip
}

java_prepare() {
	# Remove tests
	rm -R org/bouncycastle/tsp/test || die
}
