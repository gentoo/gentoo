# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

FORTRAN_NEEDED=fortran

inherit autotools eutils flag-o-matic fortran-2 toolchain-funcs

DESCRIPTION="Fast C library for the Discrete Fourier Transform"
SRC_URI="http://www.fftw.org/${P}.tar.gz"
HOMEPAGE="http://www.fftw.org"

DEPEND="mpi? ( virtual/mpi )"
RDEPEND="${DEPEND}"

SLOT="2.1"
LICENSE="GPL-2+"
IUSE="doc float fortran mpi openmp threads static-libs"

KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

pkg_setup() {
	use openmp && FORTRAN_NEED_OPENMP="1"
	fortran-2_pkg_setup
	# this one is reported to cause trouble on pentium4 m series
	filter-mfpmath "sse"

	# here I need (surprise) to increase optimization:
	# --enable-i386-hacks requires -fomit-frame-pointer to work properly
	if use x86; then
		is-flag "-fomit-frame-pointer" || append-flags "-fomit-frame-pointer"
	fi
	if use openmp && [[ $(tc-getCC) == *gcc* ]] && ! tc-has-openmp; then
		ewarn "You are using gcc and OpenMP is only available with gcc >= 4.2 "
		ewarn "If you want to build fftw with OpenMP, abort now,"
		ewarn "and switch CC to an OpenMP capable compiler"
		ewarn "Otherwise the configure script will select POSIX threads."
	fi
	use openmp && [[ $(tc-getCC)$ == icc* ]] && append-ldflags $(no-as-needed)
}

src_prepare() {
	# doc suggests installing single and double precision versions
	#  via separate compilations. will do in two separate source trees
	# since some sed'ing is done during the build
	# (?if --enable-type-prefix is set?)

	epatch \
		"${FILESDIR}"/${P}-as-needed.patch \
		"${FILESDIR}"/${P}-configure.in.patch \
		"${FILESDIR}"/${P}-no-test.patch \
		"${FILESDIR}"/${P}-cc.patch \
		"${FILESDIR}"/${P}-texinfo5.1.patch

	# fix info files
	for infofile in doc/fftw*info*; do
		cat >> ${infofile} <<-EOF
			INFO-DIR-SECTION Libraries
			START-INFO-DIR-ENTRY
			* fftw: (fftw).				${DESCRIPTION}
			END-INFO-DIR-ENTRY
		EOF
	done

	sed -i 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' configure.in || die

	eautoreconf

	cd "${WORKDIR}"
	cp -R ${P} ${P}-double
	mv ${P} ${P}-single
	ln -s ${P}-single ${P}
}

src_configure() {
	local myconf="
		--enable-shared
		--enable-type-prefix
		--enable-vec-recurse
		$(use_enable fortran)
		$(use_enable mpi)
		$(use_enable static-libs static)
		$(use_enable x86 i386-hacks)"
	if use openmp; then
		myconf="${myconf}
			--enable-threads
			--with-openmp"
	elif use threads; then
		myconf="${myconf}
			--enable-threads
			--without-openmp"
	else
		myconf="${myconf}
			--disable-threads
			--without-openmp"
	fi
	cd "${S}-single"
	econf ${myconf} \
		--enable-float \
		--with-gcc=$(tc-getCC)

	cd "${S}-double"
	econf ${myconf} \
		--with-gcc=$(tc-getCC)
}

src_compile() {
	local dir
	for dir in "${S}-single" "${S}-double"
	do
		einfo "Running compilation in ${dir}"
		emake -C ${dir}
	done
}

src_test() {
	local dir
	for dir in "${S}-single" "${S}-double"
	do
		einfo "Running tests in ${dir}"
		emake -C ${dir} -j1 check
	done
}

src_install () {
	# both builds are installed in the same place
	# libs are distinguished by prefix (s or d), see docs for details

	local dir
	for dir in "${S}-single" "${S}-double"
	do
		emake DESTDIR="${D}" -C ${dir} install
	done

	insinto /usr/include
	doins fortran/fftw_f77.i
	dodoc AUTHORS ChangeLog NEWS TODO README README.hacks
	use doc && dohtml doc/*

	if use float; then
		for f in "${ED}"/usr/{include,$(get_libdir)}/*sfft*; do
			ln -s $(basename ${f}) ${f/sfft/fft}
		done
		for f in "${ED}"/usr/{include,$(get_libdir)}/*srfft*; do
			ln -s $(basename ${f}) ${f/srfft/rfft}
		done
	else
		for f in "${ED}"/usr/{include,$(get_libdir)}/*dfft*; do
			ln -s $(basename ${f}) ${f/dfft/fft}
		done
		for f in "${ED}"/usr/{include,$(get_libdir)}/*drfft*; do
			ln -s $(basename ${f}) ${f/drfft/rfft}
		done
	fi
}
