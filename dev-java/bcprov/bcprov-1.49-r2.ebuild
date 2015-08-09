# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

MY_P="${PN}-jdk15on-${PV/./}"
DESCRIPTION="Java cryptography APIs"
HOMEPAGE="http://www.bouncycastle.org/java.html"
SRC_URI="http://www.bouncycastle.org/download/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x64-macos"

# Tests are currently broken. Needs further investigation.
# java.security.NoSuchAlgorithmException: Cannot find any provider supporting McElieceFujisakiWithSHA256
RESTRICT="test"

# The src_unpack find needs a new find
# https://bugs.gentoo.org/show_bug.cgi?id=182276
DEPEND=">=virtual/jdk-1.5
	userland_GNU? ( >=sys-apps/findutils-4.3 )
	app-arch/unzip
	test? ( dev-java/junit:4 )"
RDEPEND=">=virtual/jre-1.5"

IUSE="userland_GNU"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	default

	cd "${S}" || die
	unpack ./src.zip
}

java_prepare() {
	mkdir "${S}"/classes || die

	if use test ; then
		java-pkg_jar-from --build-only junit-4
	fi
}

src_compile() {
	find . -name "*.java" > "${T}"/src.list

	local cp
	if use test ; then
		cp="-cp junit.jar"
	else
		sed -i '/\/test\//d' "${T}"/src.list || die "Failed to remove test classes"
	fi

	ejavac $cp -encoding ISO-8859-1 -d "${S}"/classes "@${T}"/src.list

	cd "${S}"/classes || die

	jar -cf "${S}"/${PN}.jar * || die "Failed to create jar."
}

src_test() {
	java -cp ${PN}.jar:junit.jar org.bouncycastle.pqc.jcajce.provider.test.AllTests | tee pqc.tests
	java -cp ${PN}.jar:junit.jar org.bouncycastle.ocsp.test.AllTests | tee oscp.tests
	java -cp ${PN}.jar:junit.jar org.bouncycastle.jce.provider.test.AllTests | tee jce.tests

	grep -q FAILURES *.tests && die "Tests failed."
}

src_install() {
	java-pkg_dojar ${PN}.jar

	use source && java-pkg_dosrc org
	use doc && java-pkg_dojavadoc docs
}
