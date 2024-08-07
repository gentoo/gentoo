# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="" # Empty since we only pick what's not packaged
JAVA_TESTING_FRAMEWORKS="junit"

inherit flag-o-matic toolchain-funcs java-pkg-2 java-pkg-simple

DESCRIPTION="Freenet REference Daemon"
HOMEPAGE="https://github.com/hyphanet/contrib/"
SRC_URI="https://github.com/hyphanet/contrib/archive/v${PV}.tar.gz -> freenet-ext-${PV}.tar.gz"
S="${WORKDIR}/contrib-${PV}"

LICENSE="public-domain"
SLOT="29"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

CP_DEPEND="dev-java/log4j-12-api:2"

DEPEND="${CP_DEPEND}
	dev-libs/gmp:0=
	>=virtual/jdk-1.8:*
"
RDEPEND="${CP_DEPEND}
	!dev-java/fec:0
	dev-libs/gmp
	>=virtual/jre-1.8:*
"

PATCHES=(
	"${FILESDIR}/freenet-ext-29-convert-jcpuid.patch"
	"${FILESDIR}/freenet-ext-29-csrc.patch"
	"${FILESDIR}/freenet-ext-29-tests.patch"
)

# Including onionnetworks' fec would cause net-p2p/freenet these test failures:
# There were 3 failures:
# 1) testSimpleRev(freenet.client.CodeTest)
# java.lang.NullPointerException: inStream parameter is null
# 	at java.base/java.util.Objects.requireNonNull(Objects.java:248)
# 	at java.base/java.util.Properties.load(Properties.java:406)
# 	at com.onionnetworks.fec.DefaultFECCodeFactory.<init>(DefaultFECCodeFactory.java:42)
# 	at com.onionnetworks.fec.FECCodeFactory.getDefault(FECCodeFactory.java:46)
# 	at freenet.client.CodeTest.testSimpleRev(CodeTest.java:97)
# 2) testShifted(freenet.client.CodeTest)
# java.lang.NullPointerException: inStream parameter is null
# 	at java.base/java.util.Objects.requireNonNull(Objects.java:248)
# 	at java.base/java.util.Properties.load(Properties.java:406)
# 	at com.onionnetworks.fec.DefaultFECCodeFactory.<init>(DefaultFECCodeFactory.java:42)
# 	at com.onionnetworks.fec.FECCodeFactory.getDefault(FECCodeFactory.java:46)
# 	at freenet.client.CodeTest.testShifted(CodeTest.java:126)
# 3) testSimple(freenet.client.CodeTest)
# java.lang.NullPointerException: inStream parameter is null
# 	at java.base/java.util.Objects.requireNonNull(Objects.java:248)
# 	at java.base/java.util.Properties.load(Properties.java:406)
# 	at com.onionnetworks.fec.DefaultFECCodeFactory.<init>(DefaultFECCodeFactory.java:42)
# 	at com.onionnetworks.fec.FECCodeFactory.getDefault(FECCodeFactory.java:46)
# 	at freenet.client.CodeTest.testSimple(CodeTest.java:112)
#
# FAILURES!!!
# Tests run: 1051,  Failures: 3

JAVA_RESOURCE_DIRS="res"
JAVA_SRC_DIR=(
	fec/{src,common/{src,tools}} # this is what causes above mentioned test failures
	freenet_ext
	java/{freenet,net/i2p}
)
JAVA_TEST_GENTOO_CLASSPATH="junit"
JAVA_TEST_SRC_DIR="fec/common/test/src"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
	mkdir res || die
	mv {fec/lib,res}/fec.properties || die
}

src_compile() {
	java-pkg-simple_src_compile

	local compile_lib
	compile_lib() {
		local name="${1}"
		local file="${2}"
		shift 2

		"$(tc-getCC)" "${@}" ${CFLAGS} $(java-pkg_get-jni-cflags) \
			${LDFLAGS} -shared -fPIC "-Wl,-soname,lib${name}.so" \
			"${file}" -o "lib${name}.so"
	}

	cd "${S}/NativeBigInteger/jbigi" || die "unable to cd to jbigi"
	compile_lib jbigi src/jbigi.c -Iinclude -lgmp ||
		die "unable to build jbigi"

	if use amd64 || use x86; then
		cd "${S}/jcpuid" || die "unable to cd to jcpuid"
		compile_lib jcpuid src/jcpuid.c -Iinclude ||
			die "unable to build jcpuid"
	fi

	cd "${S}"/fec/src/csrc || die
	append-flags -fPIC
	emake CC=$(tc-getCC) CFLAGS="${CFLAGS} $(java-pkg_get-jni-cflags)"
}

src_test () {
	# fec/common/test/src/com/onionnetworks/util/BlockDigestInputStreamTest.java:47:
	# error: incompatible types: String cannot be converted to boolean
	#             assert("Equal Hashes");Util.arraysEqual(buf.b,buf.off,
	#                    ^
	# fec/common/test/src/com/onionnetworks/util/BzeroTest.java:24:
	# error: incompatible types: String cannot be converted to boolean
	#             assert("Empty: off="+off+",len="+len);checkArray(b2,b,off,len);;
	#                                             ^
	# fec/common/test/src/com/onionnetworks/util/BzeroTest.java:37:
	# error: incompatible types: String cannot be converted to boolean
	#             assert("Filled : off="+off+",len="+len);checkArray(b2,b,off,len);;
	#                                               ^
	# 3 errors
	rm fec/common/test/src/com/onionnetworks/util/BlockDigestInputStreamTest.java || die
	rm fec/common/test/src/com/onionnetworks/util/BzeroTest.java || die

	# only 3 tests are run while " grep -nr 'public void test' " gives 38 matches
	java-pkg-simple_src_test
}

src_install() {
	java-pkg-simple_src_install

	# this jar file compiled from dev-java/fec lets freenet pass tests
#	java-pkg_dojar "${FILESDIR}/fec.jar"

	java-pkg_doso NativeBigInteger/jbigi/libjbigi.so

	# net-p2p/freenet would pass tests without them
	java-pkg_doso fec/src/csrc/libfec{8,16}.so

	if use amd64 || use x86; then
		java-pkg_doso jcpuid/libjcpuid.so
	fi
}
