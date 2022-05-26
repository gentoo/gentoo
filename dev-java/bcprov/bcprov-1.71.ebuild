# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.bouncycastle:bcprov-jdk18on:1.71"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple check-reqs

DESCRIPTION="Java cryptography APIs"
HOMEPAGE="https://www.bouncycastle.org/java.html"
SRC_URI="https://github.com/bcgit/bc-java/archive/r${PV/./rv}.tar.gz -> bc-java-r${PV/./rv}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

DEPEND=">=virtual/jdk-11:*"
RDEPEND=">=virtual/jre-1.8:*"
BDEPEND="app-arch/zip"

DOCS=( ../{README,SECURITY}.md )
HTML_DOCS=( ../{CONTRIBUTORS,index}.html )

S="${WORKDIR}/bc-java-r${PV/./rv}/prov"

JAVA_SRC_DIR=(
	"src/main/java"
	"../core/src/main/java"	# package org.bouncycastle.asn1 does not exist
	"src/main/jdk1.9"	# https://bugs.gentoo.org/797634
)
JAVA_RESOURCE_DIRS="src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR=( "src/test/java" "../core/src/test/java" )
JAVA_TEST_RESOURCE_DIRS=( "src/test/resources" "../core/src/test/resources" )

JAVA_TEST_EXTRA_ARGS="-Dbc.test.data.home=${S}/../core/src/test/data"

# Depending on vm_version 11 or 17 there are 2 different errrors
# 1) testJCE(org.bouncycastle.jce.provider.test.SimpleTestTest)
# junit.framework.AssertionFailedError: index 29 KeyStore: Exception: java.security.KeyStoreException: BKS-V1 not found
#         at junit.framework.Assert.fail(Assert.java:57)
#         at junit.framework.TestCase.fail(TestCase.java:223)
#         at org.bouncycastle.jce.provider.test.SimpleTestTest.testJCE(SimpleTestTest.java:26)
#
# 1) testJCE(org.bouncycastle.jce.provider.test.SimpleTestTest)
# junit.framework.AssertionFailedError: index 9 BlockCipher: IDEA/PGPCFB/NoPadding failed encryption - java.io.IOException: javax.crypto.ShortBufferException: output buffer too short for input.
#         at junit.framework.Assert.fail(Assert.java:57)
#         at junit.framework.TestCase.fail(TestCase.java:223)
#         at org.bouncycastle.jce.provider.test.SimpleTestTest.testJCE(SimpleTestTest.java:26)
JAVA_TEST_RUN_ONLY=(
	"org.bouncycastle.asn1.test.AllTests"
	"org.bouncycastle.crypto.agreement.test.AllTests"
	"org.bouncycastle.crypto.ec.test.AllTests"
	"org.bouncycastle.crypto.prng.test.AllTests"
	"org.bouncycastle.crypto.test.AllTests"
	"org.bouncycastle.jcajce.provider.test.AllTests"
#	"org.bouncycastle.jce.provider.test.AllTests"	# bug #827146
	"org.bouncycastle.jce.provider.test.nist.AllTests"
	"org.bouncycastle.jce.provider.test.rsa3.AllTests"
	"org.bouncycastle.pqc.crypto.lms.AllTests"
	"org.bouncycastle.pqc.crypto.test.AllTests"
	"org.bouncycastle.pqc.jcajce.provider.test.AllTests"
	"org.bouncycastle.util.encoders.test.AllTests"
)

check_env() {
	if use test; then
		# this is needed only for tests
		CHECKREQS_MEMORY="2048M"
		check-reqs_pkg_pretend
	fi
}

pkg_pretend() {
	check_env
}

pkg_setup() {
	check_env
}

src_prepare() {
	default
	java-pkg_clean ..
}

src_test() {
	JAVA_TEST_EXTRA_ARGS+=" -Xmx${CHECKREQS_MEMORY}"
	java-pkg-simple_src_test
}

src_install() {
	default
	einstalldocs
	docinto html
	dodoc -r ../docs

	# These files are not present in the upstream jar but are used for tests
	# Removing them from the jar file after testing
	zip --delete "${S}"/bcprov.jar \
		"org/bouncycastle/pqc/crypto/ntru/*" \
		"org/bouncycastle/pqc/math/ntru/*" \
		|| die "cleaning after tests failed"

	java-pkg-simple_src_install
}
