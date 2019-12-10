# Copyright 2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit java-pkg-2 toolchain-funcs

DESCRIPTION='jbigi library used by net-vpn/i2p'
HOMEPAGE='https://geti2p.net'
SRC_URI="https://download.i2p2.de/releases/${PV}/i2psource_${PV}.tar.bz2"

LICENSE='public-domain'
SLOT='0'
KEYWORDS='~amd64 ~x86'
IUSE='test'
RESTRICT="!test? ( test )"

DEPEND='
	dev-libs/gmp:0=
	virtual/jdk:1.8
'
RDEPEND="${DEPEND}"

S="${WORKDIR}/i2p-${PV}/core"

PATCHES=(
	"${FILESDIR}/${P}-asmfix.patch"
)

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

	cd "${S}/c/jbigi/jbigi" &&
		compile_lib jbigi src/jbigi.c -Iinclude -lgmp ||
		die 'unable to build jbigi'

	if use amd64 || use x86; then
		cd "${S}/c/jcpuid" &&
			compile_lib jcpuid src/jcpuid.c -Iinclude ||
			die 'unable to build jcpuid'
	fi

	if use test; then
		cd "${S}/java/src" &&
			ejavac -encoding UTF-8 net/i2p/util/NativeBigInteger.java ||
			die 'unable to build tests'
	fi
}

src_test() {
	cd "${S}/java/src" &&
		"$(java-config -J)" -Djava.library.path="${S}/c/jbigi/jbigi" net/i2p/util/NativeBigInteger ||
		die 'unable to pass tests'
}

src_install() {
	dolib.so c/jbigi/jbigi/libjbigi.so

	if use amd64 || use x86; then
		dolib.so c/jcpuid/libjcpuid.so
	fi
}
