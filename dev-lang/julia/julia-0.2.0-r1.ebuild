# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=5

inherit eutils multilib pax-utils

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
		LLVM_CONFIG=/usr/bin/llvm-config USE_BLAS64=0"

# Disabling use of 64-bit integers. If you want 64-bit integers then you need to use a BLAS implementation from the
# science overlay, and julia-9999 also from the science overlay.

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
	# Detect what BLAS and LAPACK implementations are being used
	local BLAS_LIB="$($(tc-getPKG_CONFIG) --libs-only-l blas | sed 's/ .*$//')"
	local LAPACK_LIB="$($(tc-getPKG_CONFIG) --libs-only-l lapack | sed 's/ .*$//')"
	sed -e "s|-lblas|${BLAS_LIB}|" -i Make.inc || die
	sed -e "s|libblas|${BLAS_LIB/-l/lib}.so|" -i Make.inc || die
	sed -e "s|-llapack|${LAPACK_LIB}|" -i Make.inc || die
	sed -e "s|liblapack|${LAPACK_LIB/-l/lib}.so|" -i Make.inc || die
	sed -e "s|JL_PRIVATE_LIBDIR = lib/julia|JL_PRIVATE_LIBDIR = $(get_libdir)/julia|" \
		-e "s|JL_LIBDIR = lib|JL_LIBDIR = $(get_libdir)|"  \
		-e "s|/usr/lib|/usr/$(get_libdir)|" \
		-e "s|\$(BUILD)/lib|\$(BUILD)/$(get_libdir)|g" \
		-i Make.inc || die
	# Set version to package version instead of git commit number
	sed -e "s|^JULIA_COMMIT = .*|JULIA_COMMIT = v${PV}|" -i Make.inc || die
	sed -e "s|\$(BUILD)/lib|\$(BUILD)/$(get_libdir)|g" \
		-i Makefile || die
}

src_compile() {
	mkdir -p usr/$(get_libdir) || die
	pushd usr || die
	ln -s $(get_libdir) lib || die
	popd
	emake $JULIAMAKEARGS julia-release || die
	for i in usr/bin/julia-*
	do
		if file ${i} | grep ELF >/dev/null; then
			pax-mark m ${i}
		fi
	done
	emake $JULIAMAKEARGS || die
	# makefile weirdness - avoid compile in src_install
	emake $JULIAMAKEARGS debug || die
}

src_install() {
	# config goes to /usr/etc/ - should be fixed
	emake $JULIAMAKEARGS PREFIX="${D}/usr" install || die
}
