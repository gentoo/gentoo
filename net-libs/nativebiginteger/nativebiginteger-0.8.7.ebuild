# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit eutils toolchain-funcs multilib java-pkg-2

DESCRIPTION="jbigi JNI library for net.i2p.util.NativeBigInteger java-class from I2P"
HOMEPAGE="http://www.i2p2.de"
SRC_URI="http://mirror.i2p2.de/i2psource_${PV}.tar.bz2"

LICENSE="|| ( public-domain BSD MIT )"
SLOT="0"
KEYWORDS="~amd64 x86"

IUSE="test"

DEPEND="${RDEPEND}
	>=virtual/jdk-1.5"
RDEPEND="dev-libs/gmp"

S=${WORKDIR}/i2p-${PV}/core/

src_prepare() {
	epatch "${FILESDIR}/${P}"-build-system.patch \
		"${FILESDIR}/${P}"-jcpuid-build-system.patch \
		"${FILESDIR}/${P}"-debug-all.patch \
		"${FILESDIR}/${P}"-non-android-warnings.patch \
		"${FILESDIR}/${P}"-asmfix.patch
}

src_compile() {
	tc-export CC

	cd c/jbigi/jbigi/src || die
	../../build_jbigi.sh dynamic || die

	if use test ; then
		einfo "Building tests ..."
		cd "${S}"java/src || die
		ejavac net/i2p/util/NativeBigInteger.java || die
		eend $?
	fi
	if ( use amd64 || use x86 ) ; then
		cd "${S}"c/jcpuid
		./build.sh || die
	fi
}

src_test() {
		cd java/src || die
	java -Djava.library.path="${S}"/c/jbigi/jbigi/src net/i2p/util/NativeBigInteger || die
}

src_install() {
	local os arch

	dolib c/jbigi/jbigi/src/libjbigi.so
	( use amd64 || use x86 ) && dolib c/jcpuid/lib/freenet/support/CPUInformation/libjcpuid-x86-linux.so

	## The following is needed for compatibility with earlier versions of NativeBigInteger ##

	# arch list found by "none" + grep 'JBIGI_OPTIMIZATION_.*=' core/java/src/net/i2p/util/NativeBigInteger.java
	for arch in none arm k6 k62 k63 athlon x86_64 x86_64_32 pentium pentiummmx pentium2 pentium3 pentium4 ppc ; do
		dosym libjbigi.so /usr/$(get_libdir)/libjbigi-linux-$arch.so
	done
}
