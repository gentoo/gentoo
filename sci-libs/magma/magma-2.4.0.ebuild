# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

FORTRAN_STANDARD="77 90"

inherit cuda flag-o-matic fortran-2 multilib toolchain-funcs python-any-r1

DESCRIPTION="Matrix Algebra on GPU and Multicore Architectures"
HOMEPAGE="http://icl.cs.utk.edu/magma/"
SRC_URI="http://icl.cs.utk.edu/projectsfiles/${PN}/downloads/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux"
IUSE="doc kepler maxwell pascal static-libs test volta"

#REQUIRED_USE="?? ( fermi kepler )"

RDEPEND="
	dev-util/nvidia-cuda-toolkit
	virtual/blas
	virtual/lapack"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( >=app-doc/doxygen-1.8.14-r1[dot] )
	test? ( ${PYTHON_DEPS} )"

# We have to have write acccess /dev/nvidia0 and /dev/nvidiactl and the portage
# user is (usually) not in the video group
RESTRICT="
	userpriv
	!test? ( test )
"

pkg_setup() {
	fortran-2_pkg_setup
	use test && python-any-r1_pkg_setup
	tc-check-openmp || die "Need OpenMP to compile ${P}"
}

src_prepare() {
	# distributed pc file not so useful so replace it
	cat <<-EOF > ${PN}.pc
		prefix=${EPREFIX}/usr
		libdir=\${prefix}/$(get_libdir)
		includedir=\${prefix}/include/${PN}
		Name: ${PN}
		Description: ${DESCRIPTION}
		Version: ${PV}
		URL: ${HOMEPAGE}
		Libs: -L\${libdir} -lmagma
		Libs.private: -lm -lpthread -ldl -lcublas -lcudart
		Cflags: -I\${includedir}
		Requires: blas lapack
	EOF

	if [[ $(tc-getCC) =~ gcc ]]; then
		local eopenmp=-fopenmp
	elif [[ $(tc-getCC) =~ icc ]]; then
		local eopenmp=-openmp
	else
		elog "Cannot detect compiler type so not setting openmp support"
	fi
	append-flags -fPIC ${eopenmp}
	append-ldflags -Wl,-soname,lib${PN}.so.2.4 ${eopenmp}

	cuda_src_prepare
	default
}

src_configure() {
	cat <<-EOF > make.inc
		ARCH = $(tc-getAR)
		ARCHFLAGS = cr
		RANLIB = $(tc-getRANLIB)
		NVCC = nvcc
		CC = $(tc-getCXX)
		FORT = $(tc-getFC)
		INC = -I"${EPREFIX}/opt/cuda/include" -DADD_ -DCUBLAS_GFORTRAN
		CFLAGS = ${CFLAGS} -fPIC
		CXXFLAGS = ${CXXFLAGS} -fPIC
		F90FLAGS = ${FFLAGS} -fPIC -x f95-cpp-input
		FFLAGS = ${FFLAGS} -fPIC
		NVCCFLAGS = -DADD_ -DUNIX ${NVCCFLAGS}
		LDOPTS = ${LDFLAGS}
		LOADER = $(tc-getFC)
		LIBBLAS = $($(tc-getPKG_CONFIG) --libs blas)
		LIBLAPACK = $($(tc-getPKG_CONFIG) --libs lapack)
		CUDADIR = ${EPREFIX}/opt/cuda
		LIBCUDA = -L\$(CUDADIR)/$(get_libdir) -lcublas -lcudart
		LIB = -pthread -lm -ldl \$(LIBCUDA) \$(LIBBLAS) \$(LIBLAPACK) -lstdc++
	EOF
	if use volta; then
		echo >> make.inc "GPU_TARGET = Volta"
	elif use pascal; then
		echo >> make.inc "GPU_TARGET = Pascal"
	elif use maxwell; then
		echo >> make.inc "GPU_TARGET = Maxwell"
	elif use kepler; then
		echo >> make.inc "GPU_TARGET = Kepler"
	else # See http://icl.cs.utk.edu/magma/forum/viewtopic.php?f=2&t=227
		echo >> make.inc "GPU_TARGET = Tesla"
	fi
}

src_compile() {
	emake lib
	emake shared
	mv lib/lib${PN}.so{,.2.4} || die
	ln -sf lib${PN}.so.2.4 lib/lib${PN}.so.2 || die
	ln -sf lib${PN}.so.2.4 lib/lib${PN}.so || die
}

src_test() {
	emake test lapacktest
	cd testing/lin || die
	# we need to access this while running the tests
	addwrite /dev/nvidiactl
	addwrite /dev/nvidia0
	LD_LIBRARY_PATH="${S}"/lib ${EPYTHON} lapack_testing.py || die
}

src_install() {
	dolib.so lib/lib*$(get_libname)*
	use static-libs && dolib.a lib/lib*.a
	insinto /usr/include/${PN}
	doins include/*.h
	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}.pc
	local DOCS=( README ReleaseNotes )
	use doc && local HTML_DOCS=( docs/html/. )
	einstalldocs
}
