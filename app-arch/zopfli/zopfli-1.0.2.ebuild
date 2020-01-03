# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Very good, but slow, deflate or zlib compression"
HOMEPAGE="https://github.com/google/zopfli/"
SRC_URI="https://github.com/google/zopfli/archive/${P}.tar.gz"

S="${WORKDIR}/${PN}-${P}"

LICENSE="Apache-2.0"
SLOT="0/1"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux"

DOCS=( CONTRIBUTORS README README.zopflipng )

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

# zopflipng statically links an exact version of LodePNG (https://github.com/lvandeve/lodepng)

src_prepare() {
	default
	tc-export CC CXX
}

# The Makefile has no install phase
src_install() {
	dolib.so libzopfli.so*
	doheader src/zopfli/zopfli.h

	dobin ${PN}

	# This version was erroneously not bumped to match ${PV}
	dolib.so libzopflipng.so*
	doheader src/zopflipng/zopflipng_lib.h

	dobin zopflipng
}
