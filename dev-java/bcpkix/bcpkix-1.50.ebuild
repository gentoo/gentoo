# Copyright 1999-2015 Gentoo Foundation
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
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos"

# Tests are currently broken. Needs further investigation.
#
#  - java.lang.RuntimeException: java.security.NoSuchProviderException:
#    JCE cannot authenticate the provider BC
#
#  - error: package org.bouncycastle.util.test does not exist
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

	java -cp ${cp} ${pkg}.tsp.test.AllTests | tee tsp.tests
	java -cp ${cp} ${pkg}.pkcs.test.AllTests | tee pkcs.tests
	java -cp ${cp} ${pkg}.openssl.test.AllTests | tee openssl.tests
	java -cp ${cp} ${pkg}.mozilla.test.AllTests | tee mozilla.tests
	java -cp ${cp} ${pkg}.eac.test.AllTests | tee eac.tests
	java -cp ${cp} ${pkg}.dvcs.test.AllTests | tee dvcs.tests
	java -cp ${cp} ${pkg}.cms.test.AllTests | tee cms.tests
	java -cp ${cp} ${pkg}.cert.test.AllTests | tee cert.tests
	java -cp ${cp} ${pkg}.cert.ocsp.test.AllTests | tee cert.ocsp.tests
	java -cp ${cp} ${pkg}.cert.crmf.test.AllTests | tee cert.crmf.tests
	java -cp ${cp} ${pkg}.cert.cmp.test.AllTests | tee cert.cmp.tests

	grep -q FAILURES *.tests && die "Tests failed."
}

src_install() {
	java-pkg_dojar "${S}"/${PN}.jar

	use source && java-pkg_dosrc org
	use doc && java-pkg_dojavadoc docs
}
