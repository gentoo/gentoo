# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="" # Empty since we only pick what's not packaged

inherit java-pkg-2 java-pkg-simple toolchain-funcs

DESCRIPTION="Freenet REference Daemon"
HOMEPAGE="https://github.com/hyphanet/contrib/"
SRC_URI="https://github.com/hyphanet/contrib/archive/v${PV}.tar.gz -> freenet-ext-${PV}.tar.gz"
S="${WORKDIR}/contrib-${PV}"

LICENSE="public-domain"
SLOT="29"
KEYWORDS="amd64 ~arm ~arm64 ~x86"

DEPEND="
	dev-libs/gmp:0=
	>=virtual/jdk-1.8:*
"
RDEPEND="
	dev-libs/gmp
	>=virtual/jre-1.8:*
"

PATCHES=(
	"${FILESDIR}/freenet-ext-29-convert-jcpuid.patch"
)

JAVA_SRC_DIR=(
	"freenet"
	"freenet_ext"
	"i2p"
)

src_prepare() {
	default
	java-pkg-2_src_prepare
	mkdir -p i2p/net freenet || die
	# From the java directory we need "java/net/i2p"
	mv {java,i2p}/net/i2p || die
	# and "java/freenet".
	mv {java,freenet}/freenet || die
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
}

src_install() {
	java-pkg-simple_src_install

	java-pkg_doso NativeBigInteger/jbigi/libjbigi.so

	if use amd64 || use x86; then
		java-pkg_doso jcpuid/libjcpuid.so
	fi
}
