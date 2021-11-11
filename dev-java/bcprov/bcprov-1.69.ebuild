# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.bouncycastle:bcprov-jdk15on:1.69"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple check-reqs

DESCRIPTION="Java cryptography APIs"
HOMEPAGE="https://www.bouncycastle.org/java.html"
SRC_URI="https://github.com/bcgit/bc-java/archive/refs/tags/r${PV/./rv}.tar.gz -> bc-java-r${PV/./rv}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 ~x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"
BDEPEND="app-arch/zip"

DOCS=( ../{README,SECURITY}.md )
HTML_DOCS=( ../{CONTRIBUTORS,index,LICENSE}.html )

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

JAVA_TEST_RUN_ONLY=(
	"org.bouncycastle.asn1.test.AllTests"	# OK (18 tests)
	"org.bouncycastle.crypto.agreement.test.AllTests"	# OK (14 tests)
	"org.bouncycastle.crypto.ec.test.AllTests"	# OK (1 test)
	"org.bouncycastle.crypto.prng.test.AllTests" # OK (1 test)
	"org.bouncycastle.crypto.test.AllTests"	# Time: 126.95 OK (6 tests)
	"org.bouncycastle.jcajce.provider.test.AllTests"	# OK (29 tests)
	"org.bouncycastle.jce.provider.test.AllTests"	# OK (1 test)
	"org.bouncycastle.jce.provider.test.nist.AllTests"	# OK (283 tests)
	"org.bouncycastle.jce.provider.test.rsa3.AllTests"	# OK (11 tests)
	"org.bouncycastle.pqc.crypto.lms.AllTests"	# OK (17 tests)
	"org.bouncycastle.pqc.crypto.test.AllTests"	# OK (81 tests)
	"org.bouncycastle.pqc.jcajce.provider.test.AllTests"	# OK (89 tests)
	"org.bouncycastle.util.encoders.test.AllTests"	# OK (15 tests)
)

check_env() {
	if use test; then
		# this is needed only for tests
		CHECKREQS_MEMORY="1200M"
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
	cd ../ || die
	java-pkg_clean
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
