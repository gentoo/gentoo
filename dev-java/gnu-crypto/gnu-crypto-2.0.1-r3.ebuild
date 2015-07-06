# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/gnu-crypto/gnu-crypto-2.0.1-r3.ebuild,v 1.1 2015/07/06 20:10:43 monsieurp Exp $

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="GNU Crypto cryptographic primitives for Java"
HOMEPAGE="http://www.gnu.org/software/gnu-crypto/"
SRC_URI="ftp://ftp.gnupg.org/GnuPG/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"

EANT_BUILD_XML="${S}/build.xml"
EANT_BUILD_TARGET="jar"

EANT_DOC_TARGET="javadoc"

java_prepare() {
	epatch "${FILESDIR}/${P}-jdk15.patch"
}

src_compile() {
	java-pkg-2_src_compile
}

TEST_TARGETS=(
	check
	ent
)

src_test() {
	for target in ${TEST_TARGETS[@]}; do
		EANT_TEST_TARGET=${target} \
			java-pkg-2_src_test
	done
}

GNU_CRYPTO_JARS=(
	"${PN}"
	"${PN}-test"
	javax-crypto
	javax-security
)

src_install() {
	for jar in ${GNU_CRYPTO_JARS[@]}; do
		java-pkg_dojar "lib/${jar}.jar"
	done

	use doc && java-pkg_dojavadoc docs/api
	use source && java-pkg_dosrc source/* jce/* security/*

	dodoc AUTHORS ChangeLog NEWS README THANKS
}
