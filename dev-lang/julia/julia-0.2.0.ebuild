# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/julia/julia-0.2.0.ebuild,v 1.4 2014/02/26 03:37:12 patrick Exp $
EAPI=5

inherit eutils

DESCRIPTION="High-level, high-performance dynamic programming language for technical computing"

HOMEPAGE="http://julialang.org/"

# uses gfortran in some places, dependencies don't reflect that yet

# tarball remade because upstream lacks submodules, so it's not able to build
# soo ... they bundle a split out part of v8 that has no build system that makes sense
# double-conversion nailed in to make build system happy
# dSFMT is not meant to be packaged
SRC_URI="http://gentooexperimental.org/~patrick/${P}.tar.bz2
	http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/SFMT/dSFMT-src-2.2.tar.gz -> dsfmt-2.2.tar.gz
	http://double-conversion.googlecode.com/files/double-conversion-1.1.1.tar.gz"

LICENSE="MIT"
SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE=""

S="${WORKDIR}"

# Avoid fragile duplication - see compile and install phases
JULIAMAKEARGS="QUIET_MAKE= USE_SYSTEM_LLVM=1 USE_SYSTEM_READLINE=1 USE_SYSTEM_PCRE=1 USE_SYSTEM_LIBM=1 \
		USE_SYSTEM_GMP=1 USE_SYSTEM_LIBUNWIND=1 USE_SYSTEM_PATCHELF=1 USE_SYSTEM_FFTW=1 USE_SYSTEM_ZLIB=1 \
		USE_SYSTEM_MPFR=1 USE_SYSTEM_SUITESPARSE=1  USE_SYSTEM_ARPACK=1 USE_SYSTEM_BLAS=1 USE_SYSTEM_LAPACK=1 \
		LLVM_CONFIG=/usr/bin/llvm-config"

# scons is a dep of double-conversion
DEPEND="
	=sys-devel/llvm-3.3*
	dev-lang/perl
	sys-libs/readline
	dev-libs/libpcre
	dev-util/scons
	dev-libs/gmp
	sys-libs/libunwind
	dev-util/patchelf
	sci-libs/fftw
	sys-libs/zlib
	dev-libs/mpfr
	sci-libs/suitesparse
	sci-libs/arpack
	virtual/lapack
	virtual/blas
	"
RDEPEND="sys-libs/readline"

src_prepare() {
	#uurgh, no fetching in ebuild
	sed -i -e 's~$(JLDOWNLOAD)~/bin/true~' deps/Makefile || die "Oopsie"
	sed -i -e 's~git submodule~/bin/true~g' deps/Makefile || die "Ooopsie"
	# and we need to build stuff, so ... let's just copy around and pray!
	mkdir -p deps/random
	cp "${DISTDIR}/dsfmt-2.2.tar.gz" deps/random/
	cp "${DISTDIR}/double-conversion-1.1.1.tar.gz" deps/
	# Some cleanups to avoid an OpenBlas dep, and remove some useless git errors
	sed -e "s|-lblas|$($(tc-getPKG_CONFIG) --libs blas)|" Make.inc || die
	sed -e 's/$(shell git rev-parse --short=10 HEAD)/v0.2.0/' Make.inc || die
}

src_compile() {
	emake $JULIAMAKEARGS || die
	# makefile weirdness - avoid compile in src_install
	emake $JULIAMAKEARGS debug || die
}

src_install() {
	# config goes to /usr/etc/ - should be fixed
	emake $JULIAMAKEARGS PREFIX="${D}/usr" install || die
}
