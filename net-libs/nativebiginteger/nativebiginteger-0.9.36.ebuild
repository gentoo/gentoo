# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs multilib java-pkg-opt-2

DESCRIPTION="jbigi JNI library for net.i2p.util.NativeBigInteger java-class from I2P"
HOMEPAGE="http://www.i2p2.de"
SRC_URI="https://download.i2p2.de/releases/${PV}/i2psource_${PV}.tar.bz2"

LICENSE="|| ( public-domain BSD MIT )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="test"

RDEPEND="dev-libs/gmp:0="
DEPEND="
	${RDEPEND}
	test? ( >=virtual/jdk-1.7 )"

S="${WORKDIR}/i2p-${PV}/core"

PATCHES=(
	"${FILESDIR}/${P}"-asmfix.patch
)

QA_PRESTRIPPED="usr/lib64/libjcpuid.so"

QA_SONAME="usr/lib64/libjcpuid.so"

pkg_setup() {
	if use test; then
		java-pkg-opt-2_pkg_setup
		export JAVA_HOME=$(java-config -O)
	fi
}

src_compile() {
	tc-export CC

	cd c/jbigi/jbigi/src &&
		../../build_jbigi.sh dynamic ||
		die 'unable to build jbigi'

	if use test; then
		cd "${S}/java/src" &&
			ejavac -encoding UTF-8 net/i2p/util/NativeBigInteger.java ||
			die 'unable to build tests'
	fi

	if ( use amd64 || use x86 ); then
		cd "${S}/c/jcpuid" &&
			./build.sh ||
			die 'unable to build jcpuid'
	fi
}

src_test() {
	cd java/src &&
		$(java-config -J) -Djava.library.path="${S}/c/jbigi/jbigi/src" net/i2p/util/NativeBigInteger ||
		die 'unable to pass tests'
}

src_install() {
	dolib c/jbigi/jbigi/src/libjbigi.so

	if ( use amd64 || use x86 ); then
		newlib.so \
			"c/jcpuid/lib/freenet/support/CPUInformation/libjcpuid-$(tc-arch)-linux.so" \
			libjcpuid.so
	fi
}
