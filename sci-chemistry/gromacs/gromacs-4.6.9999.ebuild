# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

TEST_PV="4.6.6"
MANUAL_PV="4.6.6"

CMAKE_MAKEFILE_GENERATOR="ninja"

inherit bash-completion-r1 cmake-utils cuda eutils multilib readme.gentoo-r1 toolchain-funcs

if [[ $PV = *9999* ]]; then
	EGIT_REPO_URI="git://git.gromacs.org/gromacs.git
		https://gerrit.gromacs.org/gromacs.git
		https://github.com/gromacs/gromacs.git
		http://repo.or.cz/r/gromacs.git"
	EGIT_BRANCH="release-4-6"
	inherit git-r3
	LIVE_DEPEND="doc? (
		app-doc/doxygen
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
		media-gfx/imagemagick
		sys-apps/coreutils
	)"
else
	SRC_URI="ftp://ftp.gromacs.org/pub/${PN}/${P}.tar.gz
		doc? ( ftp://ftp.gromacs.org/pub/manual/manual-${MANUAL_PV}.pdf -> ${PN}-manual-${MANUAL_PV}.pdf )
		test? ( http://gerrit.gromacs.org/download/regressiontests-${TEST_PV}.tar.gz )"
	LIVE_DEPEND=""
	KEYWORDS="~alpha ~amd64 ~arm ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
fi

ACCE_IUSE="cpu_flags_x86_sse2 cpu_flags_x86_sse4_1 cpu_flags_x86_fma4 cpu_flags_x86_avx"

DESCRIPTION="The ultimate molecular dynamics simulation package"
HOMEPAGE="http://www.gromacs.org/"

# see COPYING for details
# http://repo.or.cz/w/gromacs.git/blob/HEAD:/COPYING
#        base,    vmd plugins, fftpack from numpy,  blas/lapck from netlib,        memtestG80 library,  mpi_thread lib
LICENSE="LGPL-2.1 UoI-NCSA !mkl? ( !fftw? ( BSD ) !blas? ( BSD ) !lapack? ( BSD ) ) cuda? ( LGPL-3 ) threads? ( BSD )"
SLOT="0/${PV}"
IUSE="X blas cuda doc -double-precision +fftw gsl lapack mkl mpi +offensive openmp +single-precision test +threads zsh-completion ${ACCE_IUSE}"

CDEPEND="
	X? (
		x11-libs/libX11
		x11-libs/libSM
		x11-libs/libICE
		)
	blas? ( virtual/blas )
	cuda? ( >=dev-util/nvidia-cuda-toolkit-4.2.9-r1 )
	fftw? ( sci-libs/fftw:3.0 )
	gsl? ( sci-libs/gsl )
	lapack? ( virtual/lapack )
	mkl? ( sci-libs/mkl )
	mpi? ( virtual/mpi )"
DEPEND="${CDEPEND}
	virtual/pkgconfig
	${LIVE_DEPEND}
	doc? ( app-doc/doxygen )"
RDEPEND="${CDEPEND}"

REQUIRED_USE="
	|| ( single-precision double-precision )
	cuda? ( single-precision )
	mkl? ( !blas !fftw !lapack )"

DOCS=( AUTHORS README )
HTML_DOCS=( "${ED}"/usr/share/gromacs/html/ )

pkg_pretend() {
	[[ $(gcc-version) == "4.1" ]] && die "gcc 4.1 is not supported by gromacs"
	use openmp && ! tc-has-openmp && \
		die "Please switch to an openmp compatible compiler"
}

src_unpack() {
	if [[ ${PV} != *9999 ]]; then
		default
	else
		git-r3_src_unpack
		if use doc; then
			EGIT_REPO_URI="git://git.gromacs.org/manual.git" \
			EGIT_BRANCH="release-4-6" EGIT_COMMIT="release-4-6" \
			EGIT_CHECKOUT_DIR="${WORKDIR}/manual"\
				git-r3_src_unpack
		fi
		if use test; then
			EGIT_REPO_URI="git://git.gromacs.org/regressiontests.git" \
			EGIT_BRANCH="release-4-6" EGIT_COMMIT="release-4-6" \
			EGIT_CHECKOUT_DIR="${WORKDIR}/regressiontests"\
				git-r3_src_unpack
		fi
	fi
}

src_prepare() {
	#notes/todos
	# -on apple: there is framework support

	cmake-utils_src_prepare

	use cuda && cuda_src_prepare

	GMX_DIRS=""
	use single-precision && GMX_DIRS+=" float"
	use double-precision && GMX_DIRS+=" double"

	if use test; then
		for x in ${GMX_DIRS}; do
			mkdir -p "${WORKDIR}/${P}_${x}" || die
			cp -al "${WORKDIR}/regressiontests"* "${WORKDIR}/${P}_${x}/tests" || die
		done
	fi

	DOC_CONTENTS="Gromacs can use sci-chemistry/vmd to read additional file formats"
}

src_configure() {
	local mycmakeargs_pre=( ) extra fft_opts=( )

	#go from slowest to fastest acceleration
	local acce="None"
	use cpu_flags_x86_sse2 && acce="SSE2"
	use cpu_flags_x86_sse4_1 && acce="SSE4.1"
	use cpu_flags_x86_fma4 && acce="AVX_128_FMA"
	use cpu_flags_x86_avx && acce="AVX_256"

	#to create man pages, build tree binaries are executed (bug #398437)
	[[ ${CHOST} = *-darwin* ]] && \
		extra+=" -DCMAKE_BUILD_WITH_INSTALL_RPATH=OFF"

	if use fftw; then
		fft_opts=( -DGMX_FFT_LIBRARY=fftw3 )
	elif use mkl && has_version "=sci-libs/mkl-10*"; then
		fft_opts=( -DGMX_FFT_LIBRARY=mkl
			-DMKL_INCLUDE_DIR="${MKLROOT}/include"
			-DMKL_LIBRARIES="$(echo /opt/intel/mkl/10.0.5.025/lib/*/libmkl.so);$(echo /opt/intel/mkl/10.0.5.025/lib/*/libiomp*.so)"
		)
	elif use mkl; then
		local bits=$(get_libdir)
		fft_opts=( -DGMX_FFT_LIBRARY=mkl
			-DMKL_INCLUDE_DIR="$(echo /opt/intel/*/mkl/include)"
			-DMKL_LIBRARIES="$(echo /opt/intel/*/mkl/lib/*${bits/lib}/libmkl_rt.so)"
		)
	else
		fft_opts=( -DGMX_FFT_LIBRARY=fftpack )
	fi

	mycmakeargs_pre+=(
		"${fft_opts[@]}"
		-DGMX_X11=$(usex X)
		-DGMX_EXTERNAL_BLAS=$(usex blas)
		-DGMX_GSL=$(usex gsl)
		-DGMX_EXTERNAL_LAPACK=$(usex lapack)
		-DGMX_OPENMP=$(usex openmp)
		-DGMX_COOL_QUOTES=$(usex offensive)
		-DGMX_DEFAULT_SUFFIX=off
		-DGMX_ACCELERATION="$acce"
		-DGMXLIB="$(get_libdir)"
		-DGMX_VMD_PLUGIN_PATH="${EPREFIX}/usr/$(get_libdir)/vmd/plugins/*/molfile/"
		-DGMX_PREFIX_LIBMD=ON
		-DGMX_X86_AVX_GCC_MASKLOAD_BUG=OFF
		-DGMX_USE_GCC44_BUG_WORKAROUND=OFF
		${extra}
	)

	for x in ${GMX_DIRS}; do
		einfo "Configuring for ${x} precision"
		local suffix=""
		#if we build single and double - double is suffixed
		use double-precision && use single-precision && \
			[[ ${x} = "double" ]] && suffix="_d"
		local p
		[[ ${x} = "double" ]] && p="-DGMX_DOUBLE=ON" || p="-DGMX_DOUBLE=OFF"
		local cuda=( "-DGMX_GPU=OFF" )
		[[ ${x} = "float" ]] && use cuda && \
			cuda=( -DGMX_GPU=ON )
		mycmakeargs=( ${mycmakeargs_pre[@]} ${p} -DGMX_MPI=OFF
			-DGMX_THREAD_MPI=$(usex threads) "${cuda[@]}" -DGMX_OPENMM=OFF
			"$(use test && echo -DREGRESSIONTEST_PATH="${WORKDIR}/${P}_${x}/tests")"
			-DGMX_BINARY_SUFFIX="${suffix}" -DGMX_LIBS_SUFFIX="${suffix}" )
		BUILD_DIR="${WORKDIR}/${P}_${x}" cmake-utils_src_configure
		use mpi || continue
		einfo "Configuring for ${x} precision with mpi"
		mycmakeargs=( ${mycmakeargs_pre[@]} ${p} -DGMX_THREAD_MPI=OFF
			-DGMX_MPI=ON ${cuda} -DGMX_OPENMM=OFF
			-DGMX_BINARY_SUFFIX="_mpi${suffix}" -DGMX_LIBS_SUFFIX="_mpi${suffix}" )
		BUILD_DIR="${WORKDIR}/${P}_${x}_mpi" CC="mpicc" cmake-utils_src_configure
	done
}

src_compile() {
	for x in ${GMX_DIRS}; do
		einfo "Compiling for ${x} precision"
		BUILD_DIR="${WORKDIR}/${P}_${x}"\
			cmake-utils_src_compile
		use mpi || continue
		einfo "Compiling for ${x} precision with mpi"
		BUILD_DIR="${WORKDIR}/${P}_${x}_mpi"\
			cmake-utils_src_compile mdrun
	done
}

src_test() {
	for x in ${GMX_DIRS}; do
		BUILD_DIR="${WORKDIR}/${P}_${x}"\
			cmake-utils_src_make check
	done
}

src_install() {
	for x in ${GMX_DIRS}; do
		BUILD_DIR="${WORKDIR}/${P}_${x}" \
			cmake-utils_src_install
		#manual can only be build after gromacs was installed once in image
		if use doc && [[ $PV = *9999*  && ! -d ${WORKDIR}/manual_build ]]; then
			mycmakeargs=( -DGMXBIN="${ED}"/usr/bin -DGMXSRC="${WORKDIR}/${P}" )
			BUILD_DIR="${WORKDIR}"/manual_build \
				CMAKE_USE_DIR="${WORKDIR}/manual" cmake-utils_src_configure
			[[ ${CHOST} = *-darwin* ]] && \
				export DYLD_LIBRARY_PATH="${DYLD_LIBRARY_PATH}${DYLD_LIBRARY_PATH:+:}${ED}/usr/$(get_libdir)"
			BUILD_DIR="${WORKDIR}"/manual_build cmake-utils_src_make
			[[ ${CHOST} = *-darwin* ]] && DYLD_LIBRARY_PATH="${ED}/usr/$(get_libdir)"
			newdoc "${WORKDIR}"/manual_build/gromacs.pdf "${PN}-manual-${PV}.pdf"
		fi
		use mpi || continue
		BUILD_DIR="${WORKDIR}/${P}_${x}_mpi" \
			DESTDIR="${D}" cmake-utils_src_make install-mdrun
	done

	use doc && [[ $PV != *9999* ]] && dodoc "${DISTDIR}/${PN}-manual-${MANUAL_PV}.pdf"
	newbashcomp "${ED}"/usr/bin/completion.bash ${PN}
	if use zsh-completion ; then
		insinto /usr/share/zsh/site-functions
		newins "${ED}"/usr/bin/completion.zsh _${PN}
	fi
	rm -f "${ED}"usr/bin/completion.*
	rm -rf "${ED}"usr/share/gromacs/html
	rm -f "${ED}"usr/bin/g_options*
	rm -f "${ED}"usr/bin/GMXRC*

	readme.gentoo_create_doc
}

pkg_postinst() {
	einfo
	einfo  "Please read and cite:"
	einfo  "Gromacs 4, J. Chem. Theory Comput. 4, 435 (2008). "
	einfo  "https://dx.doi.org/10.1021/ct700301q"
	if use offensive; then
		einfo
		einfo  $(g_luck)
		einfo  "For more Gromacs cool quotes (gcq) add g_luck to your .bashrc"
	fi
	einfo
	readme.gentoo_print_elog
}
