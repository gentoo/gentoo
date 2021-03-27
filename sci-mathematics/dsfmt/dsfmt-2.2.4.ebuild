# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MYPN=dSFMT
MYP=${MYPN}-${PV}

DESCRIPTION="Double precision SIMD-oriented Fast Mersenne Twister library"
HOMEPAGE="http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/SFMT"
SRC_URI="https://github.com/MersenneTwister-Lab/dSFMT/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

S="${WORKDIR}/${MYP}"

soname="lib${MYPN}.so"

src_compile() {
	emake CCFLAGS="${CFLAGS}"
	$(tc-getCC) -fPIC -shared -DDSFMT_SHLIB -DDSFMT_DO_NOT_USE_OLD_NAMES ${LDFLAGS} ${CFLAGS} -Wl,-soname=${soname} -o ${soname} ${MYPN}.c || die
}

src_test() {
	emake std-check
}

src_install() {
	doheader dSFMT.c d*.h
	dodoc README*txt CHANGE*
	dolib.so ${soname}
}
