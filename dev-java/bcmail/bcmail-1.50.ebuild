# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/bcmail/bcmail-1.50.ebuild,v 1.5 2015/06/14 17:52:47 monsieurp Exp $

EAPI="5"

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

MY_P="${PN}-jdk15on-${PV/./}"

DESCRIPTION="Java cryptography APIs"
HOMEPAGE="http://www.bouncycastle.org/java.html"
SRC_URI="http://www.bouncycastle.org/download/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos"

COMMON_DEPEND=">=dev-java/bcprov-${PV}:0[test?]
		~dev-java/bcpkix-${PV}:0[test?]
		dev-java/sun-jaf:0
		java-virtuals/javamail:0"

DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	test? ( dev-java/junit:0 )
	${COMMON_DEPEND}"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPEND}"

S="${WORKDIR}/${MY_P}"

# Package can't be build with test as bcprov and bcpkix can't be built with test.
RESTRICT="test"

src_unpack() {
	default
	cd "${S}"
	unpack ./src.zip
}

java_prepare() {
	mkdir "${S}"/classes

	if use test ; then
		java-pkg_jar-from --build-only junit
	fi
}

src_compile() {
	find org -name "*.java" > "${T}"/src.list

	local cp="$(java-pkg_getjars bcprov,bcpkix,sun-jaf,javamail)"
	if use test ; then
		cp="${cp}:junit.jar"
	else
		sed -i '/\/test\//d' "${T}"/src.list || die "Failed to remove test classes"
	fi

	ejavac -d "${S}"/classes -cp ${cp} "@${T}"/src.list

	cd "${S}"/classes
	jar -cf "${S}"/${PN}.jar * || die "failed to create jar"
}

src_test() {
	local cp="${PN}.jar:bcprov.jar:bcpkix.jar:junit.jar"

	java -cp ${cp} org.bouncycastle.mail.smime.test.AllTests | tee mail.tests

	grep -q FAILURES *.tests && die "Tests failed."
}

src_install() {
	java-pkg_dojar "${S}"/${PN}.jar

	use source && java-pkg_dosrc org
	use doc && java-pkg_dojavadoc docs
}
