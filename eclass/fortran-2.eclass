# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: fortran-2.eclass
# @MAINTAINER:
# jlec@gentoo.org
# sci@gentoo.org
# @AUTHOR:
# Author Justin Lecher <jlec@gentoo.org>
# Test functions provided by Sebastien Fabbro and Kacper Kowalik
# @SUPPORTED_EAPIS: 4 5 6 7
# @BLURB: Simplify fortran compiler management
# @DESCRIPTION:
# If you need a fortran compiler, then you should be inheriting this eclass.
# In case you only need optional support, please export FORTRAN_NEEDED before
# inheriting the eclass.
#
# The eclass tests for working fortran compilers
# and exports the variables FC and F77.
# Optionally, it checks for extended capabilities based on
# the variable options selected in the ebuild
# The only phase function exported is fortran-2_pkg_setup.
# @EXAMPLE:
# FORTRAN_NEEDED="lapack fortran"
#
# inherit fortran-2
#
# FORTRAN_NEED_OPENMP=1

inherit toolchain-funcs
case ${EAPI:-0} in
	# not used in the eclass, but left for backward compatibility with legacy users
	4|5|6) inherit eutils ;;
	7) ;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac

EXPORT_FUNCTIONS pkg_setup

if [[ ! ${_FORTRAN_2_CLASS} ]]; then

# @ECLASS-VARIABLE: FORTRAN_NEED_OPENMP
# @DESCRIPTION:
# Set to "1" in order to automatically have the eclass abort if the fortran
# compiler lacks openmp support.
: ${FORTRAN_NEED_OPENMP:=0}

# @ECLASS-VARIABLE: FORTRAN_STANDARD
# @DESCRIPTION:
# Set this, if a special dialect needs to be supported.
# Generally not needed as default is sufficient.
#
# Valid settings are any combination of: 77 90 95 2003
: ${FORTRAN_STANDARD:=77}

# @ECLASS-VARIABLE: FORTRAN_NEEDED
# @DESCRIPTION:
# If your package has an optional fortran support, set this variable
# to the space separated list of USE triggering the fortran
# dependency.
#
# e.g. FORTRAN_NEEDED=lapack would result in
#
# DEPEND="lapack? ( virtual/fortran )"
#
# If unset, we always depend on virtual/fortran.
: ${FORTRAN_NEEDED:=always}

for _f_use in ${FORTRAN_NEEDED}; do
	case ${_f_use} in
		always)
			DEPEND+=" virtual/fortran"
			RDEPEND+=" virtual/fortran"
			break
			;;
		no)
			break
			;;
		test)
			DEPEND+=" ${_f_use}? ( virtual/fortran )"
			;;
		*)
			DEPEND+=" ${_f_use}? ( virtual/fortran )"
			RDEPEND+=" ${_f_use}? ( virtual/fortran )"
			;;
	esac
done
unset _f_use

# @FUNCTION: fortran_int64_abi_fflags
# @DESCRIPTION:
# Return the Fortran compiler flag to enable 64 bit integers for
# array indices
fortran_int64_abi_fflags() {
	debug-print-function ${FUNCNAME} "${@}"

	local _FC=$(tc-getFC)
	if [[ ${_FC} == *gfortran* ]]; then
		echo "-fdefault-integer-8"
	elif [[ ${_FC} == ifort ]]; then
		echo "-integer-size 64"
	else
		die "Compiler flag for 64bit interger for ${_FC} unknown"
	fi
}

# @FUNCTION: _fortran_write_testsuite
# @INTERNAL
# @DESCRIPTION:
# writes fortran test code
_fortran_write_testsuite() {
	debug-print-function ${FUNCNAME} "${@}"

	local filebase=${T}/test-fortran

	# f77 code
	cat <<- EOF > "${filebase}.f" || die
	       end
	EOF

	# f90/95 code
	cat <<- EOF > "${filebase}.f90" || die
	end
	EOF

	# f2003 code
	cat <<- EOF > "${filebase}.f03" || die
	       procedure(), pointer :: p
	       end
	EOF
}

# @FUNCTION: _fortran_compile_test
# @USAGE: <compiler> [dialect]
# @INTERNAL
# @DESCRIPTION:
# Takes fortran compiler as first argument and dialect as second.
# Checks whether the passed fortran compiler speaks the fortran dialect
_fortran_compile_test() {
	debug-print-function ${FUNCNAME} "${@}"

	local filebase=${T}/test-fortran
	local fcomp=${1}
	local fdia=${2}
	local fcode=${filebase}.f${fdia}
	local ret

	[[ $# -lt 1 ]] && \
		die "_fortran_compile_test() needs at least one argument"

	[[ -f ${fcode} ]] || _fortran_write_testsuite

	${fcomp} "${fcode}" -o "${fcode}.x" \
		>> "${T}"/_fortran_compile_test.log 2>&1
	ret=$?

	rm -f "${fcode}.x"
	return ${ret}
}

# @FUNCTION: _fortran-has-openmp
# @RETURN: return code of the compiler
# @INTERNAL
# @DESCRIPTION:
# See if the fortran supports OpenMP.
_fortran-has-openmp() {
	debug-print-function ${FUNCNAME} "${@}"

	local flag
	local filebase=${T}/test-fc-openmp
	local fcode=${filebase}.f
	local ret
	local _fc=$(tc-getFC)

	cat <<- EOF > "${fcode}" || die
	       call omp_get_num_threads
	       end
	EOF

	for flag in -fopenmp -xopenmp -openmp -mp -omp -qsmp=omp; do
		${_fc} ${flag} "${fcode}" -o "${fcode}.x" \
			&>> "${T}"/_fortran_compile_test.log
		ret=$?
		[[ ${ret} == 0 ]] && break
	done

	rm -f "${fcode}.x"
	return ${ret}
}

# @FUNCTION: _fortran_die_msg
# @INTERNAL
# @DESCRIPTION:
# Detailed description how to handle fortran support
_fortran_die_msg() {
	debug-print-function ${FUNCNAME} "${@}"

	eerror
	eerror "Please install currently selected gcc version with USE=fortran."
	eerror "If you intend to use a different compiler then gfortran, please"
	eerror "set FC variable accordingly and take care that the necessary"
	eerror "fortran dialects are supported."
	eerror
	die "Currently no working fortran compiler is available (see ${T}/_fortran_compile_test.log for information)"
}

# @FUNCTION: _fortran_test_function
# @INTERNAL
# @DESCRIPTION:
# Internal test function for working fortran compiler.
# It is called in fortran-2_pkg_setup.
_fortran_test_function() {
	debug-print-function ${FUNCNAME} "${@}"

	local dialect

	: ${F77:=$(tc-getFC)}

	: ${FORTRAN_STANDARD:=77}
	for dialect in ${FORTRAN_STANDARD}; do
		case ${dialect} in
			77) _fortran_compile_test $(tc-getF77) || \
				_fortran_die_msg ;;
			90|95) _fortran_compile_test $(tc-getFC) 90 || \
				_fortran_die_msg ;;
			2003) _fortran_compile_test $(tc-getFC) 03 || \
				_fortran_die_msg ;;
			2008) die "Future" ;;
			*) die "${dialect} is not a Fortran dialect." ;;
		esac
	done

	tc-export F77 FC
	einfo "Using following Fortran compiler:"
	einfo "  F77: ${F77}"
	einfo "  FC:  ${FC}"

	if [[ ${FORTRAN_NEED_OPENMP} == 1 ]]; then
		if _fortran-has-openmp; then
			einfo "${FC} has OPENMP support"
		else
			die "Please install current gcc with USE=openmp or set the FC variable to a compiler that supports OpenMP"
		fi
	fi
}

# @FUNCTION: _fortran-2_pkg_setup
# @INTERNAL
# @DESCRIPTION:
# _The_ fortran-2_pkg_setup() code
_fortran-2_pkg_setup() {
	for _f_use in ${FORTRAN_NEEDED}; do
	case ${_f_use} in
		always)
			_fortran_test_function && break 2
			;;
		no)
			einfo "Forcing fortran support off"
			break
			;;
		*)
			if use ${_f_use}; then
				_fortran_test_function && break 2
			else
				unset FC
				unset F77
			fi
			;;
		esac
	done
}


# @FUNCTION: fortran-2_pkg_setup
# @DESCRIPTION:
# Setup functionality,
# checks for a valid fortran compiler and optionally for its openmp support.
fortran-2_pkg_setup() {
	debug-print-function ${FUNCNAME} "${@}"

	if [[ ${MERGE_TYPE} != binary ]]; then
		_fortran-2_pkg_setup
	fi
}

_FORTRAN_2_ECLASS=1
fi
