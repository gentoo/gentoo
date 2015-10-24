# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-pkg-simple

MY_P="${PN}-jdk15on-${PV/./}"

DESCRIPTION="Java cryptography APIs"
HOMEPAGE="http://www.bouncycastle.org/java.html"
SRC_URI="http://www.bouncycastle.org/download/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="1.50"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos"

CDEPEND="dev-java/bcprov:${SLOT}
	dev-java/bcpkix:${SLOT}
	java-virtuals/jaf:0
	dev-java/junit:0
	dev-java/oracle-javamail:0"

DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

S="${WORKDIR}/${MY_P}"

JAVA_GENTOO_CLASSPATH="
	jaf
	junit
	bcprov-${SLOT}
	bcpkix-${SLOT}
	oracle-javamail
"

# Package can't be built with test as bcprov and bcpkix can't be built with test.
RESTRICT="test"

src_unpack() {
	default
	cd "${S}"
	unpack ./src.zip
}

java_prepare() {
	JAVA_RM_FILES=(
		org/bouncycastle/mail/smime/test/*
		org/bouncycastle/mail/smime/examples/CreateSignedMail.java
	)
}

src_compile() {
	java-pkg-simple_src_compile
}

src_install() {
	java-pkg-simple_src_install
	use source && java-pkg_dosrc org
}
