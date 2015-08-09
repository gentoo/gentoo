# Copyright 1999-2014 Gentoo Foundation
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
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos"

# Tests are currently broken. Appears to need older version of bcprov; but since bcprov is not slotted, this can cause conflicts.
# Needs further investigation; though, only a small part has tests and there are no tests for bcpg itself.
RESTRICT="test"

COMMON_DEPEND="
	>=dev-java/bcprov-${PV}:0[test?]"

DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	test? ( dev-java/junit:0 )
	${COMMON_DEPEND}"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPEND}"

S="${WORKDIR}/${MY_P}"

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

	java-pkg_jar-from bcprov
}

src_compile() {
	find org -name "*.java" > "${T}"/src.list

	local cp="bcprov.jar"
	if use test ; then
		cp="${cp}:junit.jar"
	else
		sed -i '/\/test\//d' "${T}"/src.list || die "Failed to remove test classes"
	fi

	ejavac -d "${S}"/classes -cp ${cp} "@${T}"/src.list

	cd "${S}"/classes || die

	jar -cf "${S}"/${PN}.jar * || die "Failed to create jar."
}

src_test() {
	local cp="${PN}.jar:bcprov.jar:junit.jar"
	local pkg="org.bouncycastle"

	java -cp ${cp} ${pkg}.openpgp.test.AllTests | tee openpgp.tests

	grep -q FAILURES *.tests && die "Tests failed."
}

src_install() {
	java-pkg_dojar "${S}"/${PN}.jar

	use source && java-pkg_dosrc org
	use doc && java-pkg_dojavadoc docs
}
