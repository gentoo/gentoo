# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 toolchain-funcs

DESCRIPTION="Python package for convex optimization"
HOMEPAGE="
	https://cvxopt.org/
	https://github.com/cvxopt/cvxopt/
	https://pypi.org/project/cvxopt/
"
# no sdist, as of 1.3.1
SRC_URI="
	https://github.com/${PN}/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+dsdp examples fftw +glpk gsl"

DEPEND="
	virtual/blas
	virtual/lapack
	sci-libs/amd:0=
	sci-libs/cholmod:0=
	sci-libs/colamd:0=
	sci-libs/suitesparseconfig:0=
	sci-libs/umfpack:0=
	dsdp? ( sci-libs/dsdp:0= )
	fftw? ( sci-libs/fftw:3.0= )
	glpk? ( >=sci-mathematics/glpk-4.49:0= )
	gsl? ( sci-libs/gsl:0= )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=dev-python/setuptools-scm-6.2[${PYTHON_USEDEP}]
	virtual/pkgconfig
"

distutils_enable_sphinx doc/source \
	dev-python/sphinx-rtd-theme
distutils_enable_tests pytest

# The BLAS_LIB and LAPACK_LIB variables (among others) in cvxopt's
# setup.py are passed in as colon-delimited strings. So, for example,
# if your blas "l" flags are "-lblas -lcblas", then cvxopt wants
# "blas;cblas" for BLAS_LIB.
#
# The following function takes a flag type ("l", "L", or "I") as its
# first argument and a list of packages as its remaining arguments. It
# outputs a list of libraries, library paths, or include paths,
# respectively, for the given packages, retrieved using pkg-config and
# deduplicated, in the appropriate format.
#
cvxopt_output() {
	local FLAGNAME="${1}"
	shift
	local PACKAGES="${@}"

	local PKGCONFIG_MODE
	case "${FLAGNAME}" in
	l) PKGCONFIG_MODE="--libs-only-l";;
	L) PKGCONFIG_MODE="--libs-only-L";;
	I) PKGCONFIG_MODE="--cflags-only-I";;
	*) echo "invalid flag name: ${FLAGNAME}"; exit 1;;
	esac

	local CVXOPT_OUTPUT=""
	local PKGCONFIG_ITEM
	for PKGCONFIG_ITEM in $($(tc-getPKG_CONFIG) ${PKGCONFIG_MODE} ${PACKAGES})
	do
	# First strip off the leading "-l", "-L", or "-I", and replace
	# it with a semicolon...
	PKGCONFIG_ITEM=";${PKGCONFIG_ITEM#-${FLAGNAME}}"

	# Now check to see if this element is already present in the
	# list, and skip it if it is. This eliminates multiple entries
	# from winding up in the list when multiple package arguments are
	# passed to this function.
	if [[ "${CVXOPT_OUTPUT}" != "${CVXOPT_OUTPUT%${PKGCONFIG_ITEM}}" ]]
	then
		# It was already the last entry in the list, so skip it.
		continue
	elif [[ "${CVXOPT_OUTPUT}" != "${CVXOPT_OUTPUT%${PKGCONFIG_ITEM};*}" ]]
	then
		# It was an earlier entry in the list. These two cases are
		# separate to ensure that we can e.g. find ";m" at the end
		# of the list, but that we don't find ";metis" in the process.
		continue
	fi

	# It isn't in the list yet, so append it.
	CVXOPT_OUTPUT+="${PKGCONFIG_ITEM}"
	done

	# Strip the leading ";" from ";foo;bar" before output.
	echo "${CVXOPT_OUTPUT#;}"
}

src_configure() {
	# Mandatory dependencies.
	export CVXOPT_BLAS_LIB="$(cvxopt_output l blas)"
	export CVXOPT_BLAS_LIB_DIR="${EPREFIX}/usr/$(get_libdir);$(cvxopt_output L blas)"
	export CVXOPT_LAPACK_LIB="$(cvxopt_output l lapack)"
	export CVXOPT_SUITESPARSE_LIB_DIR="${EPREFIX}/usr/$(get_libdir);$(cvxopt_output L umfpack cholmod amd colamd suitesparseconfig)"

	# Most of these CVXOPT_* variables can be blank or have "empty"
	# entries and the resulting command-line with e.g. "-L -L/some/path"
	# won't hurt anything. The INC_DIR variables, however, cause
	# problems, because at least gcc doesn't like a bare "-I". We
	# pre-populate these variable with something safe so that setup.py
	# doesn't look in the wrong place if pkg-config doesn't return any
	# extra -I directories. This is
	#
	#  https://github.com/cvxopt/cvxopt/issues/167
	#
	CVXOPT_SUITESPARSE_INC_DIR="${EPREFIX}/usr/include"
	local SUITESPARSE_LOCAL_INCS="$(cvxopt_output I umfpack cholmod amd colamd suitesparseconfig)"
	if [[ -n "${SUITESPARSE_LOCAL_INCS}" ]]; then
		CVXOPT_SUITESPARSE_INC_DIR+=";${SUITESPARSE_LOCAL_INCS}"
	fi
	export CVXOPT_SUITESPARSE_INC_DIR

	# optional dependencies
	if use dsdp; then
		# no pkg-config file at the moment
		export CVXOPT_BUILD_DSDP=1
		export CVXOPT_DSDP_LIB_DIR="${EPREFIX}/usr/$(get_libdir)"
		export CVXOPT_DSDP_INC_DIR="${EPREFIX}/usr/include"
	fi

	if use fftw; then
		export CVXOPT_BUILD_FFTW=1
		export CVXOPT_FFTW_LIB_DIR="${EPREFIX}/usr/$(get_libdir);$(cvxopt_output L fftw3)"
		CVXOPT_FFTW_INC_DIR="${EPREFIX}/usr/include"
		FFTW_LOCAL_INCS="$(cvxopt_output I fftw3)"
		if [[ -n "${FFTW_LOCAL_INCS}" ]]; then
			CVXOPT_FFTW_INC_DIR+=";${FFTW_LOCAL_INCS}"
		fi
		export CVXOPT_FFTW_INC_DIR
	fi

	if use glpk; then
		# no pkg-config file at the moment
		export CVXOPT_BUILD_GLPK=1
		export CVXOPT_GLPK_LIB_DIR="${EPREFIX}/usr/$(get_libdir)"
		export CVXOPT_GLPK_INC_DIR="${EPREFIX}/usr/include"
	fi

	if use gsl; then
		export CVXOPT_BUILD_GSL=1
		export CVXOPT_GSL_LIB_DIR="${EPREFIX}/usr/$(get_libdir);$(cvxopt_output L gsl)"
		CVXOPT_GSL_INC_DIR="${EPREFIX}/usr/include"
		GSL_LOCAL_INCS="$(cvxopt_output I gsl)"
		if [[ -n "${GSL_LOCAL_INCS}" ]]; then
			CVXOPT_GSL_INC_DIR+=";${GSL_LOCAL_INCS}"
		fi
		export CVXOPT_GSL_INC_DIR
	fi

	export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
}

python_install_all() {
	distutils-r1_python_install_all
	if use examples; then
		dodoc -r examples
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
}
