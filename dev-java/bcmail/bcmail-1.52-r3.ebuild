# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-pkg-simple

MY_P="${PN}-jdk15on-${PV/./}"

DESCRIPTION="Java cryptography APIs"
HOMEPAGE="http://www.bouncycastle.org/java.html"
SRC_URI="http://www.bouncycastle.org/download/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="1.52"
KEYWORDS="amd64 ppc64 x86 ~amd64-linux ~x86-linux ~x64-macos"

CDEPEND="
	dev-java/junit:0
	dev-java/bcprov:${SLOT}
	dev-java/bcpkix:${SLOT}
	dev-java/oracle-javamail:0"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

S="${WORKDIR}/${MY_P}"

JAVA_GENTOO_CLASSPATH="
	junit
	bcprov-${SLOT}
	bcpkix-${SLOT}
	oracle-javamail
"

# Package can't be built with test as bcprov and bcpkix can't be built with test.
RESTRICT="test"

src_unpack() {
	default
	cd "${S}" || die
	unpack ./src.zip
}

src_prepare() {
	default
	rm -rv \
		org/bouncycastle/mail/smime/test/* \
		org/bouncycastle/mail/smime/examples/CreateSignedMail.java || die
}

src_compile() {
	java-pkg-simple_src_compile
}

src_install() {
	java-pkg-simple_src_install
	use source && java-pkg_dosrc org
}
