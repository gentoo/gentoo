# Copyright 2018-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="test"

inherit java-pkg-2 toolchain-funcs

DESCRIPTION="jbigi library used by net-vpn/i2p"
HOMEPAGE="https://geti2p.net"
SRC_URI="https://files.i2p-projekt.de/${PV}/i2psource_${PV}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

DEPEND="
	dev-libs/gmp:0=
	>=virtual/jdk-1.8:*
"
RDEPEND="
	>=virtual/jre-1.8:*
"

S="${WORKDIR}/i2p-${PV}"

src_prepare() {
	java-pkg-2_src_prepare
	java-pkg_clean
}

src_compile() {
	local compile_lib
	compile_lib() {
		local name="${1}"
		local file="${2}"
		shift 2

		"$(tc-getCC)" "${@}" ${CFLAGS} $(java-pkg_get-jni-cflags) \
			${LDFLAGS} -shared -fPIC "-Wl,-soname,lib${name}.so" \
			"${file}" -o "lib${name}.so"
	}

	cd "${S}/core/c/jbigi/jbigi" || die "unable to cd to jbigi"
	compile_lib jbigi src/jbigi.c -Iinclude -lgmp ||
		die "unable to build jbigi"

	if use amd64 || use x86; then
		cd "${S}/core/c/jcpuid" || die "unable to cd to jcpuid"
		compile_lib jcpuid src/jcpuid.c -Iinclude ||
			die "unable to build jcpuid"
	fi
}

src_test() {
	cd core/java/src || die "unable to cd to java/src"

	ejavac -encoding UTF-8 net/i2p/util/NativeBigInteger.java ||
		die "unable to build tests"
	"$(java-config -J)" -Djava.library.path="${S}/core/c/jbigi/jbigi" net/i2p/util/NativeBigInteger ||
		die "unable to pass tests"
}

src_install() {
	java-pkg_doso core/c/jbigi/jbigi/libjbigi.so

	if use amd64 || use x86; then
		java-pkg_doso core/c/jcpuid/libjcpuid.so
	fi
}
