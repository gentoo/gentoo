# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_MAKEFILE_GENERATOR="ninja"

inherit bash-completion-r1 cmake-utils cuda eutils multilib readme.gentoo-r1 toolchain-funcs xdg-utils

if [[ $PV = *9999* ]]; then
	EGIT_REPO_URI="git://git.gromacs.org/gromacs.git
		https://gerrit.gromacs.org/gromacs.git
		https://github.com/gromacs/gromacs.git
		http://repo.or.cz/r/gromacs.git"
	[[ $PV = 9999 ]] && EGIT_BRANCH="master" || EGIT_BRANCH="release-${PV:0:4}"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="ftp://ftp.gromacs.org/pub/${PN}/${PN}-${PV/_/-}.tar.gz
		test? ( http://gerrit.gromacs.org/download/regressiontests-${PV/_/-}.tar.gz )"
	KEYWORDS="~alpha ~amd64 ~arm ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
fi

ACCE_IUSE="cpu_flags_x86_sse2 cpu_flags_x86_sse4_1 cpu_flags_x86_fma4 cpu_flags_x86_avx cpu_flags_x86_avx2"

DESCRIPTION="The ultimate molecular dynamics simulation package"
HOMEPAGE="http://www.gromacs.org/"

# see COPYING for details
# http://repo.or.cz/w/gromacs.git/blob/HEAD:/COPYING
#        base,    vmd plugins, fftpack from numpy,  blas/lapck from netlib,        memtestG80 library,  mpi_thread lib
LICENSE="LGPL-2.1 UoI-NCSA !mkl? ( !fftw? ( BSD ) !blas? ( BSD ) !lapack? ( BSD ) ) cuda? ( LGPL-3 ) threads? ( BSD )"
SLOT="0/${PV}"
IUSE="X blas cuda +doc -double-precision +fftw +hwloc lapack mkl mpi +offensive openmp +single-precision test +threads +tng ${ACCE_IUSE}"

CDEPEND="
	X? (
		x11-libs/libX11
		x11-libs/libSM
		x11-libs/libICE
		)
	blas? ( virtual/blas )
	cuda? ( >=dev-util/nvidia-cuda-toolkit-4.2.9-r1 )
	fftw? ( sci-libs/fftw:3.0 )
	hwloc? ( sys-apps/hwloc )
	lapack? ( virtual/lapack )
	mkl? ( sci-libs/mkl )
	mpi? ( virtual/mpi )
	"
DEPEND="${CDEPEND}
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
		media-gfx/imagemagick
	)"
RDEPEND="${CDEPEND}"

REQUIRED_USE="
	|| ( single-precision double-precision )
	cuda? ( single-precision )
	mkl? ( !blas !fftw !lapack )"

DOCS=( AUTHORS README )

if [[ ${PV} != *9999 ]]; then
	S="${WORKDIR}/${PN}-${PV/_/-}"
fi

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
		if use test; then
			EGIT_REPO_URI="git://git.gromacs.org/regressiontests.git" \
			EGIT_BRANCH="${EGIT_BRANCH}" \
			EGIT_CHECKOUT_DIR="${WORKDIR}/regressiontests"\
				git-r3_src_unpack
		fi
	fi
}

src_prepare() {
	#notes/todos
	# -on apple: there is framework support

	xdg_environment_reset #591952

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
	use cpu_flags_x86_avx2 && acce="AVX2_256"

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
		-DGMX_EXTERNAL_LAPACK=$(usex lapack)
		-DGMX_OPENMP=$(usex openmp)
		-DGMX_COOL_QUOTES=$(usex offensive)
		-DGMX_USE_TNG=$(usex tng)
		-DGMX_BUILD_MANUAL=$(usex doc)
		-DGMX_HWLOC=$(usex hwloc)
		-DGMX_DEFAULT_SUFFIX=off
		-DGMX_SIMD="$acce"
		-DGMX_LIB_INSTALL_DIR="$(get_libdir)"
		-DGMX_VMD_PLUGIN_PATH="${EPREFIX}/usr/$(get_libdir)/vmd/plugins/*/molfile/"
		-DBUILD_TESTING=$(usex test)
		-DGMX_BUILD_UNITTESTS=$(usex test)
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
		mycmakeargs=(
			${mycmakeargs_pre[@]} ${p}
			-DGMX_MPI=OFF
			-DGMX_THREAD_MPI=$(usex threads)
			"${cuda[@]}"
			"$(use test && echo -DREGRESSIONTEST_PATH="${WORKDIR}/${P}_${x}/tests")"
			-DGMX_BINARY_SUFFIX="${suffix}"
			-DGMX_LIBS_SUFFIX="${suffix}"
			)
		BUILD_DIR="${WORKDIR}/${P}_${x}" cmake-utils_src_configure
		[[ ${CHOST} != *-darwin* ]] || \
		  sed -i '/SET(CMAKE_INSTALL_NAME_DIR/s/^/#/' "${WORKDIR}/${P}_${x}/gentoo_rules.cmake" || die
		use mpi || continue
		einfo "Configuring for ${x} precision with mpi"
		mycmakeargs=(
			${mycmakeargs_pre[@]} ${p}
			-DGMX_THREAD_MPI=OFF
			-DGMX_MPI=ON ${cuda}
			-DGMX_OPENMM=OFF
			-DGMX_BUILD_MDRUN_ONLY=ON
			-DBUILD_SHARED_LIBS=OFF
			-DGMX_BUILD_MANUAL=OFF
			-DGMX_BINARY_SUFFIX="_mpi${suffix}"
			-DGMX_LIBS_SUFFIX="_mpi${suffix}"
			)
		BUILD_DIR="${WORKDIR}/${P}_${x}_mpi" CC="mpicc" cmake-utils_src_configure
		[[ ${CHOST} != *-darwin* ]] || \
		  sed -i '/SET(CMAKE_INSTALL_NAME_DIR/s/^/#/' "${WORKDIR}/${P}_${x}_mpi/gentoo_rules.cmake" || die
	done
}

src_compile() {
	for x in ${GMX_DIRS}; do
		einfo "Compiling for ${x} precision"
		BUILD_DIR="${WORKDIR}/${P}_${x}"\
			cmake-utils_src_compile
		# not 100% necessary for rel ebuilds as available from website
		if use doc; then
			BUILD_DIR="${WORKDIR}/${P}_${x}"\
				cmake-utils_src_compile manual
		fi
		use mpi || continue
		einfo "Compiling for ${x} precision with mpi"
		BUILD_DIR="${WORKDIR}/${P}_${x}_mpi"\
			cmake-utils_src_compile
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
		if use doc; then
			newdoc "${WORKDIR}/${P}_${x}"/docs/manual/gromacs.pdf "${PN}-manual-${PV}.pdf"
		fi
		use mpi || continue
		BUILD_DIR="${WORKDIR}/${P}_${x}_mpi" \
			cmake-utils_src_install
	done

	if use tng; then
		insinto /usr/include/tng
		doins src/external/tng_io/include/tng/*h
	fi
	# drop unneeded stuff
	rm "${ED}"usr/bin/GMXRC* || die
	for x in "${ED}"usr/bin/gmx-completion-*.bash ; do
		local n=${x##*/gmx-completion-}
		n="${n%.bash}"
		cat "${ED}"usr/bin/gmx-completion.bash "$x" > "${T}/${n}" || die
		newbashcomp "${T}"/"${n}" "${n}"
	done
	rm "${ED}"usr/bin/gmx-completion*.bash || die
	readme.gentoo_create_doc
}

pkg_postinst() {
	einfo
	einfo  "Please read and cite:"
	einfo  "Gromacs 4, J. Chem. Theory Comput. 4, 435 (2008). "
	einfo  "https://dx.doi.org/10.1021/ct700301q"
	einfo
	readme.gentoo_print_elog
}
