# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FORTRAN_NEEDED=fortran

inherit autotools flag-o-matic fortran-2 multibuild toolchain-funcs

DESCRIPTION="Fast C library for the Discrete Fourier Transform"
HOMEPAGE="http://www.fftw.org"
SRC_URI="http://www.fftw.org/${P}.tar.gz"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

LICENSE="GPL-2+"
SLOT="2.1"
IUSE="doc float fortran mpi openmp threads static-libs"

RDEPEND="mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-as-needed.patch
	"${FILESDIR}"/${P}-configure.in.patch
	"${FILESDIR}"/${P}-no-test.patch
	"${FILESDIR}"/${P}-cc.patch
	"${FILESDIR}"/${P}-texinfo5.1.patch
)

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]] && use openmp; then
		if ! tc-has-openmp; then
			ewarn "OpenMP is not available in your current selected compiler"

			if tc-is-clang; then
				ewarn "OpenMP support in sys-devel/clang is provided by sys-libs/libomp,"
				ewarn "which you will need to build ${CATEGORY}/${PN} with USE=\"openmp\""
			fi

			die "need openmp capable compiler"
		fi
		FORTRAN_NEED_OPENMP=1
	fi

	fortran-2_pkg_setup

	MULTIBUILD_VARIANTS=( single double )
}

src_prepare() {
	default

	# fix info files
	local infofile
	for infofile in doc/fftw*info*; do
		cat >> ${infofile} <<-EOF || die
			INFO-DIR-SECTION Libraries
			START-INFO-DIR-ENTRY
			* fftw: (fftw).				${DESCRIPTION}
			END-INFO-DIR-ENTRY
		EOF
	done

	mv configure.{in,ac} || die
	sed -i 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' configure.ac || die

	eautoreconf

	# 'FAQ' is actually a dir and causes issues with einstalldocs
	rm -r FAQ || die

	multibuild_copy_sources
}

fftw_src_configure() {
	local myconf=(
		--with-gcc=$(tc-getCC)
		--enable-shared
		--enable-type-prefix
		--enable-vec-recurse
		$(use_enable fortran)
		$(use_enable mpi)
		$(use_enable static-libs static)
		$(use_enable x86 i386-hacks)
		$(use_with openmp)
	)

	if use openmp || use threads; then
		myconf+=( --enable-threads )
	else
		myconf+=( --disable-threads )
	fi

	[[ $MULTIBUILD_VARIANT == single ]] && myconf+=( --enable-float )

	econf "${myconf[@]}"
}

src_configure() {
	# this one is reported to cause trouble on pentium4 m series
	filter-mfpmath sse

	# here I need (surprise) to increase optimization:
	# --enable-i386-hacks requires -fomit-frame-pointer to work properly
	if use x86; then
		is-flag -fomit-frame-pointer || append-flags -fomit-frame-pointer
	fi
	use openmp && [[ $(tc-getCC)$ == icc* ]] && append-ldflags $(no-as-needed)

	multibuild_foreach_variant run_in_build_dir fftw_src_configure
}

src_compile() {
	multibuild_foreach_variant run_in_build_dir default_src_compile
}

src_test() {
	multibuild_foreach_variant run_in_build_dir default_src_test
}

src_install () {
	use doc && HTML_DOCS=( doc/{*.html,*.gif} )
	multibuild_foreach_variant run_in_build_dir default_src_install

	doheader fortran/fftw_f77.i

	create_fftw_symlinks() {
		local i f letter=$1
		for i in fft rfft; do
			for f in "${ED%/}"/usr/{include,$(get_libdir)}/*${letter}${i}*; do
				ln -s $(basename ${f}) ${f/${letter}${i}/${i}} || die
			done
		done
	}
	create_fftw_symlinks $(usex float s d)
}
