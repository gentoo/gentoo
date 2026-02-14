# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit"

inherit flag-o-matic java-pkg-2 java-pkg-simple toolchain-funcs

DESCRIPTION="Freenet REference Daemon"
HOMEPAGE="https://github.com/hyphanet/contrib/"
SRC_URI="https://github.com/hyphanet/contrib/archive/v${PV}.tar.gz -> freenet-ext-${PV}.tar.gz"
S="${WORKDIR}/contrib-${PV}"

LICENSE="public-domain"
SLOT="29"
KEYWORDS="amd64 ~arm64"

DEPEND="
	dev-libs/gmp:0=
	>=dev-java/log4j-12-api-2.25.2:0
	>=virtual/jdk-1.8:*
"
RDEPEND="
	!dev-java/fec:0
	!<net-p2p/freenet-0.7.5_p1503-r2:0
	dev-libs/gmp
	>=virtual/jre-1.8:*
"

PATCHES=(
	"${FILESDIR}/freenet-ext-29-convert-jcpuid.patch"
	"${FILESDIR}/freenet-ext-29-csrc.patch"
)

JAVA_CLASSPATH_EXTRA="log4j-12-api"
JAVA_RESOURCE_DIRS="res"
JAVA_SRC_DIR=(
	fec/{src,common/{src,tools}}
	freenet_ext
	java/{freenet,net/i2p}
)
JAVA_TEST_GENTOO_CLASSPATH="junit"
JAVA_TEST_SRC_DIR="fec/common/test/src"

src_prepare() {
	default # bug #780585
	java-pkg-2_src_prepare
	mkdir -p res/lib || die
	mv {fec/lib,res/lib}/fec.properties || die
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
	# fec/common/test/src/com/onionnetworks/util/BlockDigestInputStreamTest.java:47: error: ')' expected
	#             assert("Equal Hashes",Util.arraysEqual(buf.b,buf.off,
	#                                  ^
	# fec/common/test/src/com/onionnetworks/util/BlockDigestInputStreamTest.java:48: error: ';' expected
	#                                                    md.digest(),0,buf.len));
	#                                                                          ^
	# fec/common/test/src/com/onionnetworks/util/BzeroTest.java:24: error: ')' expected
	#             assert("Empty: off="+off+",len="+len,checkArray(b2,b,off,len));
	#                                                 ^
	# fec/common/test/src/com/onionnetworks/util/BzeroTest.java:24: error: ';' expected
	#             assert("Empty: off="+off+",len="+len,checkArray(b2,b,off,len));
	#                                                                          ^
	# fec/common/test/src/com/onionnetworks/util/BzeroTest.java:37: error: ')' expected
	#             assert("Filled : off="+off+",len="+len,checkArray(b2,b,off,len));
	#                                                   ^
	# fec/common/test/src/com/onionnetworks/util/BzeroTest.java:37: error: ';' expected
	#             assert("Filled : off="+off+",len="+len,checkArray(b2,b,off,len));
	#                                                                            ^
	# 6 errors
	rm fec/common/test/src/com/onionnetworks/util/BlockDigestInputStreamTest.java || die
	rm fec/common/test/src/com/onionnetworks/util/BzeroTest.java || die

	# only 3 tests are run while " grep -nr 'public void test' " gives 38 matches
	java-pkg-simple_src_test
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_doso NativeBigInteger/jbigi/libjbigi.so
	java-pkg_doso fec/src/csrc/libfec{8,16}.so

	if use amd64 || use x86; then
		java-pkg_doso jcpuid/libjcpuid.so
	fi
}
