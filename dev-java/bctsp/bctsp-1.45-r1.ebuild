# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/bctsp/bctsp-1.45-r1.ebuild,v 1.1 2013/08/15 10:40:36 tomwij Exp $

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_P="${PN}-jdk15-${PV/./}"
DESCRIPTION="Java cryptography APIs"
HOMEPAGE="http://www.bouncycastle.org/java.html"
SRC_URI="http://www.bouncycastle.org/download/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="
	dev-java/bcprov:1.45
	dev-java/bcmail:1.45"

RDEPEND="${COMMON_DEPEND}
	>=virtual/jre-1.5"

DEPEND="${COMMON_DEPEND}
	>=virtual/jdk-1.5
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
