# Copyright 2002-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: toolchain-funcs.eclass
# @MAINTAINER:
# Toolchain Ninjas <toolchain@gentoo.org>
# @BLURB: functions to query common info about the toolchain
# @DESCRIPTION:
# The toolchain-funcs aims to provide a complete suite of functions
# for gleaning useful information about the toolchain and to simplify
# ugly things like cross-compiling and multilib.  All of this is done
# in such a way that you can rely on the function always returning
# something sane.

if [[ -z ${_TOOLCHAIN_FUNCS_ECLASS} ]]; then
_TOOLCHAIN_FUNCS_ECLASS=1

inherit multilib

# tc-getPROG <VAR [search vars]> <default> [tuple]
_tc-getPROG() {
	local tuple=$1
	local v var vars=$2
	local prog=( $3 )

	var=${vars%% *}
	for v in ${vars} ; do
		if [[ -n ${!v} ]] ; then
			export ${var}="${!v}"
			echo "${!v}"
			return 0
		fi
	done

	local search=
	[[ -n $4 ]] && search=$(type -p $4-${prog[0]})
	[[ -z ${search} && -n ${!tuple} ]] && search=$(type -p ${!tuple}-${prog[0]})
	[[ -n ${search} ]] && prog[0]=${search##*/}

	export ${var}="${prog[*]}"
	echo "${!var}"
}
tc-getBUILD_PROG() {
	local vars="BUILD_$1 $1_FOR_BUILD HOST$1"
	# respect host vars if not cross-compiling
	# https://bugs.gentoo.org/630282
	tc-is-cross-compiler || vars+=" $1"
	_tc-getPROG CBUILD "${vars}" "${@:2}"
}
tc-getPROG() { _tc-getPROG CHOST "$@"; }

# @FUNCTION: tc-getAR
# @USAGE: [toolchain prefix]
# @RETURN: name of the archiver
tc-getAR() { tc-getPROG AR ar "$@"; }
# @FUNCTION: tc-getAS
# @USAGE: [toolchain prefix]
# @RETURN: name of the assembler
tc-getAS() { tc-getPROG AS as "$@"; }
# @FUNCTION: tc-getCC
# @USAGE: [toolchain prefix]
# @RETURN: name of the C compiler
tc-getCC() { tc-getPROG CC gcc "$@"; }
# @FUNCTION: tc-getCPP
# @USAGE: [toolchain prefix]
# @RETURN: name of the C preprocessor
tc-getCPP() { tc-getPROG CPP "${CC:-gcc} -E" "$@"; }
# @FUNCTION: tc-getCXX
# @USAGE: [toolchain prefix]
# @RETURN: name of the C++ compiler
tc-getCXX() { tc-getPROG CXX g++ "$@"; }
# @FUNCTION: tc-getLD
# @USAGE: [toolchain prefix]
# @RETURN: name of the linker
tc-getLD() { tc-getPROG LD ld "$@"; }
# @FUNCTION: tc-getSTRINGS
# @USAGE: [toolchain prefix]
# @RETURN: name of the strings program
tc-getSTRINGS() { tc-getPROG STRINGS strings "$@"; }
# @FUNCTION: tc-getSTRIP
# @USAGE: [toolchain prefix]
# @RETURN: name of the strip program
tc-getSTRIP() { tc-getPROG STRIP strip "$@"; }
# @FUNCTION: tc-getNM
# @USAGE: [toolchain prefix]
# @RETURN: name of the symbol/object thingy
tc-getNM() { tc-getPROG NM nm "$@"; }
# @FUNCTION: tc-getRANLIB
# @USAGE: [toolchain prefix]
# @RETURN: name of the archive indexer
tc-getRANLIB() { tc-getPROG RANLIB ranlib "$@"; }
# @FUNCTION: tc-getREADELF
# @USAGE: [toolchain prefix]
# @RETURN: name of the ELF reader
tc-getREADELF() { tc-getPROG READELF readelf "$@"; }
# @FUNCTION: tc-getOBJCOPY
# @USAGE: [toolchain prefix]
# @RETURN: name of the object copier
tc-getOBJCOPY() { tc-getPROG OBJCOPY objcopy "$@"; }
# @FUNCTION: tc-getOBJDUMP
# @USAGE: [toolchain prefix]
# @RETURN: name of the object dumper
tc-getOBJDUMP() { tc-getPROG OBJDUMP objdump "$@"; }
# @FUNCTION: tc-getF77
# @USAGE: [toolchain prefix]
# @RETURN: name of the Fortran 77 compiler
tc-getF77() { tc-getPROG F77 gfortran "$@"; }
# @FUNCTION: tc-getFC
# @USAGE: [toolchain prefix]
# @RETURN: name of the Fortran 90 compiler
tc-getFC() { tc-getPROG FC gfortran "$@"; }
# @FUNCTION: tc-getGCJ
# @USAGE: [toolchain prefix]
# @RETURN: name of the java compiler
tc-getGCJ() { tc-getPROG GCJ gcj "$@"; }
# @FUNCTION: tc-getGO
# @USAGE: [toolchain prefix]
# @RETURN: name of the Go compiler
tc-getGO() { tc-getPROG GO gccgo "$@"; }
# @FUNCTION: tc-getPKG_CONFIG
# @USAGE: [toolchain prefix]
# @RETURN: name of the pkg-config tool
tc-getPKG_CONFIG() { tc-getPROG PKG_CONFIG pkg-config "$@"; }
# @FUNCTION: tc-getRC
# @USAGE: [toolchain prefix]
# @RETURN: name of the Windows resource compiler
tc-getRC() { tc-getPROG RC windres "$@"; }
# @FUNCTION: tc-getDLLWRAP
# @USAGE: [toolchain prefix]
# @RETURN: name of the Windows dllwrap utility
tc-getDLLWRAP() { tc-getPROG DLLWRAP dllwrap "$@"; }

# @FUNCTION: tc-getBUILD_AR
# @USAGE: [toolchain prefix]
# @RETURN: name of the archiver for building binaries to run on the build machine
tc-getBUILD_AR() { tc-getBUILD_PROG AR ar "$@"; }
# @FUNCTION: tc-getBUILD_AS
# @USAGE: [toolchain prefix]
# @RETURN: name of the assembler for building binaries to run on the build machine
tc-getBUILD_AS() { tc-getBUILD_PROG AS as "$@"; }
# @FUNCTION: tc-getBUILD_CC
# @USAGE: [toolchain prefix]
# @RETURN: name of the C compiler for building binaries to run on the build machine
tc-getBUILD_CC() { tc-getBUILD_PROG CC gcc "$@"; }
# @FUNCTION: tc-getBUILD_CPP
# @USAGE: [toolchain prefix]
# @RETURN: name of the C preprocessor for building binaries to run on the build machine
tc-getBUILD_CPP() { tc-getBUILD_PROG CPP "$(tc-getBUILD_CC) -E" "$@"; }
# @FUNCTION: tc-getBUILD_CXX
# @USAGE: [toolchain prefix]
# @RETURN: name of the C++ compiler for building binaries to run on the build machine
tc-getBUILD_CXX() { tc-getBUILD_PROG CXX g++ "$@"; }
# @FUNCTION: tc-getBUILD_LD
# @USAGE: [toolchain prefix]
# @RETURN: name of the linker for building binaries to run on the build machine
tc-getBUILD_LD() { tc-getBUILD_PROG LD ld "$@"; }
# @FUNCTION: tc-getBUILD_STRINGS
# @USAGE: [toolchain prefix]
# @RETURN: name of the strings program for building binaries to run on the build machine
tc-getBUILD_STRINGS() { tc-getBUILD_PROG STRINGS strings "$@"; }
# @FUNCTION: tc-getBUILD_STRIP
# @USAGE: [toolchain prefix]
# @RETURN: name of the strip program for building binaries to run on the build machine
tc-getBUILD_STRIP() { tc-getBUILD_PROG STRIP strip "$@"; }
# @FUNCTION: tc-getBUILD_NM
# @USAGE: [toolchain prefix]
# @RETURN: name of the symbol/object thingy for building binaries to run on the build machine
tc-getBUILD_NM() { tc-getBUILD_PROG NM nm "$@"; }
# @FUNCTION: tc-getBUILD_RANLIB
# @USAGE: [toolchain prefix]
# @RETURN: name of the archive indexer for building binaries to run on the build machine
tc-getBUILD_RANLIB() { tc-getBUILD_PROG RANLIB ranlib "$@"; }
# @FUNCTION: tc-getBUILD_READELF
# @USAGE: [toolchain prefix]
# @RETURN: name of the ELF reader for building binaries to run on the build machine
tc-getBUILD_READELF() { tc-getBUILD_PROG READELF readelf "$@"; }
# @FUNCTION: tc-getBUILD_OBJCOPY
# @USAGE: [toolchain prefix]
# @RETURN: name of the object copier for building binaries to run on the build machine
tc-getBUILD_OBJCOPY() { tc-getBUILD_PROG OBJCOPY objcopy "$@"; }
# @FUNCTION: tc-getBUILD_PKG_CONFIG
# @USAGE: [toolchain prefix]
# @RETURN: name of the pkg-config tool for building binaries to run on the build machine
tc-getBUILD_PKG_CONFIG() { tc-getBUILD_PROG PKG_CONFIG pkg-config "$@"; }

# @FUNCTION: tc-getTARGET_CPP
# @USAGE: [toolchain prefix]
# @RETURN: name of the C preprocessor for the toolchain being built (or used)
tc-getTARGET_CPP() {
	if [[ -n ${CTARGET} ]]; then
		_tc-getPROG CTARGET TARGET_CPP "gcc -E" "$@"
	else
		tc-getCPP "$@"
	fi
}

# @FUNCTION: tc-export
# @USAGE: <list of toolchain variables>
# @DESCRIPTION:
# Quick way to export a bunch of compiler vars at once.
tc-export() {
	local var
	for var in "$@" ; do
		[[ $(type -t "tc-get${var}") != "function" ]] && die "tc-export: invalid export variable '${var}'"
		"tc-get${var}" > /dev/null
	done
}

# @FUNCTION: tc-is-cross-compiler
# @RETURN: Shell true if we are using a cross-compiler, shell false otherwise
tc-is-cross-compiler() {
	[[ ${CBUILD:-${CHOST}} != ${CHOST} ]]
}

# @FUNCTION: tc-cpp-is-true
# @USAGE: <condition> [cpp flags]
# @RETURN: Shell true if the condition is true, shell false otherwise.
# @DESCRIPTION:
# Evaluate the given condition using the C preprocessor for CTARGET, if
# defined, or CHOST. Additional arguments are passed through to the cpp
# command. A typical condition would be in the form defined(__FOO__).
tc-cpp-is-true() {
	local CONDITION=${1}
	shift

	$(tc-getTARGET_CPP) "${@}" -P - <<-EOF >/dev/null 2>&1
		#if ${CONDITION}
		true
		#else
		#error false
		#endif
	EOF
}

# @FUNCTION: tc-detect-is-softfloat
# @RETURN: Shell true if detection was possible, shell false otherwise
# @DESCRIPTION:
# Detect whether the CTARGET (or CHOST) toolchain is a softfloat based
# one by examining the toolchain's output, if possible.  Outputs a value
# alike tc-is-softfloat if detection was possible.
tc-detect-is-softfloat() {
	# If fetching CPP falls back to the default (gcc -E) then fail
	# detection as this may not be the correct toolchain.
	[[ $(tc-getTARGET_CPP) == "gcc -E" ]] && return 1

	case ${CTARGET:-${CHOST}} in
		# Avoid autodetection for bare-metal targets. bug #666896
		*-newlib|*-elf|*-eabi)
			return 1 ;;

		# arm-unknown-linux-gnueabi is ambiguous. We used to treat it as
		# hardfloat but we now treat it as softfloat like most everyone
		# else. Check existing toolchains to respect existing systems.
		arm*)
			if tc-cpp-is-true "defined(__ARM_PCS_VFP)"; then
				echo "no"
			else
				# Confusingly __SOFTFP__ is defined only when
				# -mfloat-abi is soft, not softfp.
				if tc-cpp-is-true "defined(__SOFTFP__)"; then
					echo "yes"
				else
					echo "softfp"
				fi
			fi

			return 0 ;;
		*)
			return 1 ;;
	esac
}

# @FUNCTION: tc-tuple-is-softfloat
# @RETURN: See tc-is-softfloat for the possible values.
# @DESCRIPTION:
# Determine whether the CTARGET (or CHOST) toolchain is a softfloat
# based one solely from the tuple.
tc-tuple-is-softfloat() {
	local CTARGET=${CTARGET:-${CHOST}}
	case ${CTARGET//_/-} in
		bfin*|h8300*)
			echo "only" ;;
		*-softfloat-*)
			echo "yes" ;;
		*-softfp-*)
			echo "softfp" ;;
		arm*-hardfloat-*|arm*eabihf)
			echo "no" ;;
		# bare-metal targets have their defaults. bug #666896
		*-newlib|*-elf|*-eabi)
			echo "no" ;;
		arm*)
			echo "yes" ;;
		*)
			echo "no" ;;
	esac
}

# @FUNCTION: tc-is-softfloat
# @DESCRIPTION:
# See if this toolchain is a softfloat based one.
# @CODE
# The possible return values:
#  - only:   the target is always softfloat (never had fpu)
#  - yes:    the target should support softfloat
#  - softfp: (arm specific) the target should use hardfloat insns, but softfloat calling convention
#  - no:     the target doesn't support softfloat
# @CODE
# This allows us to react differently where packages accept
# softfloat flags in the case where support is optional, but
# rejects softfloat flags where the target always lacks an fpu.
tc-is-softfloat() {
	tc-detect-is-softfloat || tc-tuple-is-softfloat
}

# @FUNCTION: tc-is-static-only
# @DESCRIPTION:
# Return shell true if the target does not support shared libs, shell false
# otherwise.
tc-is-static-only() {
	local host=${CTARGET:-${CHOST}}

	# *MiNT doesn't have shared libraries, only platform so far
	[[ ${host} == *-mint* ]]
}

# @FUNCTION: tc-stack-grows-down
# @DESCRIPTION:
# Return shell true if the stack grows down.  This is the default behavior
# for the vast majority of systems out there and usually projects shouldn't
# care about such internal details.
tc-stack-grows-down() {
	# List the few that grow up.
	case ${ARCH} in
	hppa|metag) return 1 ;;
	esac

	# Assume all others grow down.
	return 0
}

# @FUNCTION: tc-export_build_env
# @USAGE: [compiler variables]
# @DESCRIPTION:
# Export common build related compiler settings.
tc-export_build_env() {
	tc-export "$@"
	if tc-is-cross-compiler; then
		# Some build envs will initialize vars like:
		# : ${BUILD_LDFLAGS:-${LDFLAGS}}
		# So make sure all variables are non-empty. #526734
		: ${BUILD_CFLAGS:=-O1 -pipe}
		: ${BUILD_CXXFLAGS:=-O1 -pipe}
		: ${BUILD_CPPFLAGS:= }
		: ${BUILD_LDFLAGS:= }
	else
		# https://bugs.gentoo.org/654424
		: ${BUILD_CFLAGS:=${CFLAGS}}
		: ${BUILD_CXXFLAGS:=${CXXFLAGS}}
		: ${BUILD_CPPFLAGS:=${CPPFLAGS}}
		: ${BUILD_LDFLAGS:=${LDFLAGS}}
	fi
	export BUILD_{C,CXX,CPP,LD}FLAGS

	# Some packages use XXX_FOR_BUILD.
	local v
	for v in BUILD_{C,CXX,CPP,LD}FLAGS ; do
		export ${v#BUILD_}_FOR_BUILD="${!v}"
	done
}

# @FUNCTION: tc-env_build
# @USAGE: <command> [command args]
# @INTERNAL
# @DESCRIPTION:
# Setup the compile environment to the build tools and then execute the
# specified command.  We use tc-getBUILD_XX here so that we work with
# all of the semi-[non-]standard env vars like $BUILD_CC which often
# the target build system does not check.
tc-env_build() {
	tc-export_build_env
	CFLAGS=${BUILD_CFLAGS} \
	CXXFLAGS=${BUILD_CXXFLAGS} \
	CPPFLAGS=${BUILD_CPPFLAGS} \
	LDFLAGS=${BUILD_LDFLAGS} \
	AR=$(tc-getBUILD_AR) \
	AS=$(tc-getBUILD_AS) \
	CC=$(tc-getBUILD_CC) \
	CPP=$(tc-getBUILD_CPP) \
	CXX=$(tc-getBUILD_CXX) \
	LD=$(tc-getBUILD_LD) \
	NM=$(tc-getBUILD_NM) \
	PKG_CONFIG=$(tc-getBUILD_PKG_CONFIG) \
	RANLIB=$(tc-getBUILD_RANLIB) \
	READELF=$(tc-getBUILD_READELF) \
	"$@"
}

# @FUNCTION: econf_build
# @USAGE: [econf flags]
# @DESCRIPTION:
# Sometimes we need to locally build up some tools to run on CBUILD because
# the package has helper utils which are compiled+executed when compiling.
# This won't work when cross-compiling as the CHOST is set to a target which
# we cannot natively execute.
#
# For example, the python package will build up a local python binary using
# a portable build system (configure+make), but then use that binary to run
# local python scripts to build up other components of the overall python.
# We cannot rely on the python binary in $PATH as that often times will be
# a different version, or not even installed in the first place.  Instead,
# we compile the code in a different directory to run on CBUILD, and then
# use that binary when compiling the main package to run on CHOST.
#
# For example, with newer EAPIs, you'd do something like:
# @CODE
# src_configure() {
# 	ECONF_SOURCE=${S}
# 	if tc-is-cross-compiler ; then
# 		mkdir "${WORKDIR}"/${CBUILD}
# 		pushd "${WORKDIR}"/${CBUILD} >/dev/null
# 		econf_build --disable-some-unused-stuff
# 		popd >/dev/null
# 	fi
# 	... normal build paths ...
# }
# src_compile() {
# 	if tc-is-cross-compiler ; then
# 		pushd "${WORKDIR}"/${CBUILD} >/dev/null
# 		emake one-or-two-build-tools
# 		ln/mv build-tools to normal build paths in ${S}/
# 		popd >/dev/null
# 	fi
# 	... normal build paths ...
# }
# @CODE
econf_build() {
	local CBUILD=${CBUILD:-${CHOST}}
	tc-env_build econf --build=${CBUILD} --host=${CBUILD} "$@"
}

# @FUNCTION: tc-ld-is-gold
# @USAGE: [toolchain prefix]
# @DESCRIPTION:
# Return true if the current linker is set to gold.
tc-ld-is-gold() {
	local out

	# First check the linker directly.
	out=$($(tc-getLD "$@") --version 2>&1)
	if [[ ${out} == *"GNU gold"* ]] ; then
		return 0
	fi

	# Then see if they're selecting gold via compiler flags.
	# Note: We're assuming they're using LDFLAGS to hold the
	# options and not CFLAGS/CXXFLAGS.
	local base="${T}/test-tc-gold"
	cat <<-EOF > "${base}.c"
	int main() { return 0; }
	EOF
	out=$($(tc-getCC "$@") ${CFLAGS} ${CPPFLAGS} ${LDFLAGS} -Wl,--version "${base}.c" -o "${base}" 2>&1)
	rm -f "${base}"*
	if [[ ${out} == *"GNU gold"* ]] ; then
		return 0
	fi

	# No gold here!
	return 1
}

# @FUNCTION: tc-ld-is-lld
# @USAGE: [toolchain prefix]
# @DESCRIPTION:
# Return true if the current linker is set to lld.
tc-ld-is-lld() {
	local out

	# First check the linker directly.
	out=$($(tc-getLD "$@") --version 2>&1)
	if [[ ${out} == *"LLD"* ]] ; then
		return 0
	fi

	# Then see if they're selecting lld via compiler flags.
	# Note: We're assuming they're using LDFLAGS to hold the
	# options and not CFLAGS/CXXFLAGS.
	local base="${T}/test-tc-lld"
	cat <<-EOF > "${base}.c"
	int main() { return 0; }
	EOF
	out=$($(tc-getCC "$@") ${CFLAGS} ${CPPFLAGS} ${LDFLAGS} -Wl,--version "${base}.c" -o "${base}" 2>&1)
	rm -f "${base}"*
	if [[ ${out} == *"LLD"* ]] ; then
		return 0
	fi

	# No lld here!
	return 1
}

# @FUNCTION: tc-ld-disable-gold
# @USAGE: [toolchain prefix]
# @DESCRIPTION:
# If the gold linker is currently selected, configure the compilation
# settings so that we use the older bfd linker instead.
tc-ld-disable-gold() {
	if ! tc-ld-is-gold "$@" ; then
		# They aren't using gold, so nothing to do!
		return
	fi

	ewarn "Forcing usage of the BFD linker instead of GOLD"

	# Set up LD to point directly to bfd if it's available.
	# We need to extract the first word in case there are flags appended
	# to its value (like multilib).  #545218
	local ld=$(tc-getLD "$@")
	local bfd_ld="${ld%% *}.bfd"
	local path_ld=$(which "${bfd_ld}" 2>/dev/null)
	[[ -e ${path_ld} ]] && export LD=${bfd_ld}

	# Set up LDFLAGS to select gold based on the gcc / clang version.
	local fallback="true"
	if tc-is-gcc; then
		local major=$(gcc-major-version "$@")
		local minor=$(gcc-minor-version "$@")
		if [[ ${major} -gt 4 ]] || [[ ${major} -eq 4 && ${minor} -ge 8 ]]; then
			# gcc-4.8+ supports -fuse-ld directly.
			export LDFLAGS="${LDFLAGS} -fuse-ld=bfd"
			fallback="false"
		fi
	elif tc-is-clang; then
		local major=$(clang-major-version "$@")
		local minor=$(clang-minor-version "$@")
		if [[ ${major} -gt 3 ]] || [[ ${major} -eq 3 && ${minor} -ge 5 ]]; then
			# clang-3.5+ supports -fuse-ld directly.
			export LDFLAGS="${LDFLAGS} -fuse-ld=bfd"
			fallback="false"
		fi
	fi
	if [[ ${fallback} == "true" ]] ; then
		# <=gcc-4.7 and <=clang-3.4 require some coercion.
		# Only works if bfd exists.
		if [[ -e ${path_ld} ]] ; then
			local d="${T}/bfd-linker"
			mkdir -p "${d}"
			ln -sf "${path_ld}" "${d}"/ld
			export LDFLAGS="${LDFLAGS} -B${d}"
		else
			die "unable to locate a BFD linker to bypass gold"
		fi
	fi
}

# @FUNCTION: tc-has-openmp
# @USAGE: [toolchain prefix]
# @DESCRIPTION:
# See if the toolchain supports OpenMP.
tc-has-openmp() {
	local base="${T}/test-tc-openmp"
	cat <<-EOF > "${base}.c"
	#include <omp.h>
	int main() {
		int nthreads, tid, ret = 0;
		#pragma omp parallel private(nthreads, tid)
		{
		tid = omp_get_thread_num();
		nthreads = omp_get_num_threads(); ret += tid + nthreads;
		}
		return ret;
	}
	EOF
	$(tc-getCC "$@") -fopenmp "${base}.c" -o "${base}" >&/dev/null
	local ret=$?
	rm -f "${base}"*
	return ${ret}
}

# @FUNCTION: tc-check-openmp
# @DESCRIPTION:
# Test for OpenMP support with the current compiler and error out with
# a clear error message, telling the user how to rectify the missing
# OpenMP support that has been requested by the ebuild. Using this function
# to test for OpenMP support should be preferred over tc-has-openmp and
# printing a custom message, as it presents a uniform interface to the user.
tc-check-openmp() {
	if ! tc-has-openmp; then
		eerror "Your current compiler does not support OpenMP!"

		if tc-is-gcc; then
			eerror "Enable OpenMP support by building sys-devel/gcc with USE=\"openmp\"."
		elif tc-is-clang; then
			eerror "OpenMP support in sys-devel/clang is provided by sys-libs/libomp."
		fi

		die "Active compiler does not have required support for OpenMP"
	fi
}

# @FUNCTION: tc-has-tls
# @USAGE: [-s|-c|-l] [toolchain prefix]
# @DESCRIPTION:
# See if the toolchain supports thread local storage (TLS).  Use -s to test the
# compiler, -c to also test the assembler, and -l to also test the C library
# (the default).
tc-has-tls() {
	local base="${T}/test-tc-tls"
	cat <<-EOF > "${base}.c"
	int foo(int *i) {
		static __thread int j = 0;
		return *i ? j : *i;
	}
	EOF
	local flags
	case $1 in
		-s) flags="-S";;
		-c) flags="-c";;
		-l) ;;
		-*) die "Usage: tc-has-tls [-c|-l] [toolchain prefix]";;
	esac
	: ${flags:=-fPIC -shared -Wl,-z,defs}
	[[ $1 == -* ]] && shift
	$(tc-getCC "$@") ${flags} "${base}.c" -o "${base}" >&/dev/null
	local ret=$?
	rm -f "${base}"*
	return ${ret}
}


# Parse information from CBUILD/CHOST/CTARGET rather than
# use external variables from the profile.
tc-ninja_magic_to_arch() {
ninj() { [[ ${type} == "kern" ]] && echo $1 || echo $2 ; }

	local type=$1
	local host=$2
	[[ -z ${host} ]] && host=${CTARGET:-${CHOST}}

	case ${host} in
		aarch64*)	echo arm64;;
		alpha*)		echo alpha;;
		arm*)		echo arm;;
		avr*)		ninj avr32 avr;;
		bfin*)		ninj blackfin bfin;;
		c6x*)		echo c6x;;
		cris*)		echo cris;;
		frv*)		echo frv;;
		hexagon*)	echo hexagon;;
		hppa*)		ninj parisc hppa;;
		i?86*)
			# Starting with linux-2.6.24, the 'x86_64' and 'i386'
			# trees have been unified into 'x86'.
			# FreeBSD still uses i386
			if [[ ${type} == "kern" && ${host} == *freebsd* ]] ; then
				echo i386
			else
				echo x86
			fi
			;;
		ia64*)		echo ia64;;
		m68*)		echo m68k;;
		metag*)		echo metag;;
		microblaze*)	echo microblaze;;
		mips*)		echo mips;;
		nios2*)		echo nios2;;
		nios*)		echo nios;;
		or1k|or32*)	echo openrisc;;
		powerpc*)
			# Starting with linux-2.6.15, the 'ppc' and 'ppc64' trees
			# have been unified into simply 'powerpc', but until 2.6.16,
			# ppc32 is still using ARCH="ppc" as default
			if [[ ${type} == "kern" ]] ; then
				echo powerpc
			elif [[ ${host} == powerpc64* ]] ; then
				echo ppc64
			else
				echo ppc
			fi
			;;
		riscv*)		echo riscv;;
		s390*)		echo s390;;
		score*)		echo score;;
		sh64*)		ninj sh64 sh;;
		sh*)		echo sh;;
		sparc64*)	ninj sparc64 sparc;;
		sparc*)		[[ ${PROFILE_ARCH} == "sparc64" ]] \
						&& ninj sparc64 sparc \
						|| echo sparc
					;;
		tile*)		echo tile;;
		vax*)		echo vax;;
		x86_64*freebsd*) echo amd64;;
		x86_64*)
			# Starting with linux-2.6.24, the 'x86_64' and 'i386'
			# trees have been unified into 'x86'.
			if [[ ${type} == "kern" ]] ; then
				echo x86
			else
				echo amd64
			fi
			;;
		xtensa*)	echo xtensa;;

		# since our usage of tc-arch is largely concerned with
		# normalizing inputs for testing ${CTARGET}, let's filter
		# other cross targets (mingw and such) into the unknown.
		*)			echo unknown;;
	esac
}
# @FUNCTION: tc-arch-kernel
# @USAGE: [toolchain prefix]
# @RETURN: name of the kernel arch according to the compiler target
tc-arch-kernel() {
	tc-ninja_magic_to_arch kern "$@"
}
# @FUNCTION: tc-arch
# @USAGE: [toolchain prefix]
# @RETURN: name of the portage arch according to the compiler target
tc-arch() {
	tc-ninja_magic_to_arch portage "$@"
}

tc-endian() {
	local host=$1
	[[ -z ${host} ]] && host=${CTARGET:-${CHOST}}
	host=${host%%-*}

	case ${host} in
		aarch64*be)	echo big;;
		aarch64)	echo little;;
		alpha*)		echo little;;
		arm*b*)		echo big;;
		arm*)		echo little;;
		cris*)		echo little;;
		hppa*)		echo big;;
		i?86*)		echo little;;
		ia64*)		echo little;;
		m68*)		echo big;;
		mips*l*)	echo little;;
		mips*)		echo big;;
		powerpc*le)	echo little;;
		powerpc*)	echo big;;
		riscv*)		echo little;;
		s390*)		echo big;;
		sh*b*)		echo big;;
		sh*)		echo little;;
		sparc*)		echo big;;
		x86_64*)	echo little;;
		*)			echo wtf;;
	esac
}

# @FUNCTION: tc-get-compiler-type
# @RETURN: keyword identifying the compiler: gcc, clang, pathcc, unknown
tc-get-compiler-type() {
	local code='
#if defined(__PATHSCALE__)
	HAVE_PATHCC
#elif defined(__clang__)
	HAVE_CLANG
#elif defined(__GNUC__)
	HAVE_GCC
#endif
'
	local res=$($(tc-getCPP "$@") -E -P - <<<"${code}")

	case ${res} in
		*HAVE_PATHCC*)	echo pathcc;;
		*HAVE_CLANG*)	echo clang;;
		*HAVE_GCC*)		echo gcc;;
		*)				echo unknown;;
	esac
}

# @FUNCTION: tc-is-gcc
# @RETURN: Shell true if the current compiler is GCC, false otherwise.
tc-is-gcc() {
	[[ $(tc-get-compiler-type) == gcc ]]
}

# @FUNCTION: tc-is-clang
# @RETURN: Shell true if the current compiler is clang, false otherwise.
tc-is-clang() {
	[[ $(tc-get-compiler-type) == clang ]]
}

# Internal func.  The first argument is the version info to expand.
# Query the preprocessor to improve compatibility across different
# compilers rather than maintaining a --version flag matrix. #335943
_gcc_fullversion() {
	local ver="$1"; shift
	set -- $($(tc-getCPP "$@") -E -P - <<<"__GNUC__ __GNUC_MINOR__ __GNUC_PATCHLEVEL__")
	eval echo "$ver"
}

# @FUNCTION: gcc-fullversion
# @RETURN: compiler version (major.minor.micro: [3.4.6])
gcc-fullversion() {
	_gcc_fullversion '$1.$2.$3' "$@"
}
# @FUNCTION: gcc-version
# @RETURN: compiler version (major.minor: [3.4].6)
gcc-version() {
	_gcc_fullversion '$1.$2' "$@"
}
# @FUNCTION: gcc-major-version
# @RETURN: major compiler version (major: [3].4.6)
gcc-major-version() {
	_gcc_fullversion '$1' "$@"
}
# @FUNCTION: gcc-minor-version
# @RETURN: minor compiler version (minor: 3.[4].6)
gcc-minor-version() {
	_gcc_fullversion '$2' "$@"
}
# @FUNCTION: gcc-micro-version
# @RETURN: micro compiler version (micro: 3.4.[6])
gcc-micro-version() {
	_gcc_fullversion '$3' "$@"
}

# Internal func. Based on _gcc_fullversion() above.
_clang_fullversion() {
	local ver="$1"; shift
	set -- $($(tc-getCPP "$@") -E -P - <<<"__clang_major__ __clang_minor__ __clang_patchlevel__")
	eval echo "$ver"
}

# @FUNCTION: clang-fullversion
# @RETURN: compiler version (major.minor.micro: [3.4.6])
clang-fullversion() {
	_clang_fullversion '$1.$2.$3' "$@"
}
# @FUNCTION: clang-version
# @RETURN: compiler version (major.minor: [3.4].6)
clang-version() {
	_clang_fullversion '$1.$2' "$@"
}
# @FUNCTION: clang-major-version
# @RETURN: major compiler version (major: [3].4.6)
clang-major-version() {
	_clang_fullversion '$1' "$@"
}
# @FUNCTION: clang-minor-version
# @RETURN: minor compiler version (minor: 3.[4].6)
clang-minor-version() {
	_clang_fullversion '$2' "$@"
}
# @FUNCTION: clang-micro-version
# @RETURN: micro compiler version (micro: 3.4.[6])
clang-micro-version() {
	_clang_fullversion '$3' "$@"
}

# Returns the installation directory - internal toolchain
# function for use by _gcc-specs-exists (for flag-o-matic).
_gcc-install-dir() {
	echo "$(LC_ALL=C $(tc-getCC) -print-search-dirs 2> /dev/null |\
		awk '$1=="install:" {print $2}')"
}
# Returns true if the indicated specs file exists - internal toolchain
# function for use by flag-o-matic.
_gcc-specs-exists() {
	[[ -f $(_gcc-install-dir)/$1 ]]
}

# Returns requested gcc specs directive unprocessed - for used by
# gcc-specs-directive()
# Note; later specs normally overwrite earlier ones; however if a later
# spec starts with '+' then it appends.
# gcc -dumpspecs is parsed first, followed by files listed by "gcc -v"
# as "Reading <file>", in order.  Strictly speaking, if there's a
# $(gcc_install_dir)/specs, the built-in specs aren't read, however by
# the same token anything from 'gcc -dumpspecs' is overridden by
# the contents of $(gcc_install_dir)/specs so the result is the
# same either way.
_gcc-specs-directive_raw() {
	local cc=$(tc-getCC)
	local specfiles=$(LC_ALL=C ${cc} -v 2>&1 | awk '$1=="Reading" {print $NF}')
	${cc} -dumpspecs 2> /dev/null | cat - ${specfiles} | awk -v directive=$1 \
'BEGIN	{ pspec=""; spec=""; outside=1 }
$1=="*"directive":"  { pspec=spec; spec=""; outside=0; next }
	outside || NF==0 || ( substr($1,1,1)=="*" && substr($1,length($1),1)==":" ) { outside=1; next }
	spec=="" && substr($0,1,1)=="+" { spec=pspec " " substr($0,2); next }
	{ spec=spec $0 }
END	{ print spec }'
	return 0
}

# Return the requested gcc specs directive, with all included
# specs expanded.
# Note, it does not check for inclusion loops, which cause it
# to never finish - but such loops are invalid for gcc and we're
# assuming gcc is operational.
gcc-specs-directive() {
	local directive subdname subdirective
	directive="$(_gcc-specs-directive_raw $1)"
	while [[ ${directive} == *%\(*\)* ]]; do
		subdname=${directive/*%\(}
		subdname=${subdname/\)*}
		subdirective="$(_gcc-specs-directive_raw ${subdname})"
		directive="${directive//\%(${subdname})/${subdirective}}"
	done
	echo "${directive}"
	return 0
}

# Returns true if gcc sets relro
gcc-specs-relro() {
	local directive
	directive=$(gcc-specs-directive link_command)
	[[ "${directive/\{!norelro:}" != "${directive}" ]]
}
# Returns true if gcc sets now
gcc-specs-now() {
	local directive
	directive=$(gcc-specs-directive link_command)
	[[ "${directive/\{!nonow:}" != "${directive}" ]]
}
# Returns true if gcc builds PIEs
gcc-specs-pie() {
	local directive
	directive=$(gcc-specs-directive cc1)
	[[ "${directive/\{!nopie:}" != "${directive}" ]]
}
# Returns true if gcc builds with the stack protector
gcc-specs-ssp() {
	local directive
	directive=$(gcc-specs-directive cc1)
	[[ "${directive/\{!fno-stack-protector:}" != "${directive}" ]]
}
# Returns true if gcc upgrades fstack-protector to fstack-protector-all
gcc-specs-ssp-to-all() {
	local directive
	directive=$(gcc-specs-directive cc1)
	[[ "${directive/\{!fno-stack-protector-all:}" != "${directive}" ]]
}
# Returns true if gcc builds with fno-strict-overflow
gcc-specs-nostrict() {
	local directive
	directive=$(gcc-specs-directive cc1)
	[[ "${directive/\{!fstrict-overflow:}" != "${directive}" ]]
}
# Returns true if gcc builds with fstack-check
gcc-specs-stack-check() {
	local directive
	directive=$(gcc-specs-directive cc1)
	[[ "${directive/\{!fno-stack-check:}" != "${directive}" ]]
}


# @FUNCTION: tc-enables-pie
# @RETURN: Truth if the current compiler generates position-independent code (PIC) which can be linked into executables
# @DESCRIPTION:
# Return truth if the current compiler generates position-independent code (PIC)
# which can be linked into executables.
tc-enables-pie() {
	tc-cpp-is-true "defined(__PIE__)" ${CPPFLAGS} ${CFLAGS}
}

# @FUNCTION: tc-enables-ssp
# @RETURN: Truth if the current compiler enables stack smashing protection (SSP) on at least minimal level
# @DESCRIPTION:
# Return truth if the current compiler enables stack smashing protection (SSP)
# on level corresponding to any of the following options:
#  -fstack-protector
#  -fstack-protector-strong
#  -fstack-protector-all
tc-enables-ssp() {
	tc-cpp-is-true "defined(__SSP__) || defined(__SSP_STRONG__) || defined(__SSP_ALL__)" ${CPPFLAGS} ${CFLAGS}
}

# @FUNCTION: tc-enables-ssp-strong
# @RETURN: Truth if the current compiler enables stack smashing protection (SSP) on at least middle level
# @DESCRIPTION:
# Return truth if the current compiler enables stack smashing protection (SSP)
# on level corresponding to any of the following options:
#  -fstack-protector-strong
#  -fstack-protector-all
tc-enables-ssp-strong() {
	tc-cpp-is-true "defined(__SSP_STRONG__) || defined(__SSP_ALL__)" ${CPPFLAGS} ${CFLAGS}
}

# @FUNCTION: tc-enables-ssp-all
# @RETURN: Truth if the current compiler enables stack smashing protection (SSP) on maximal level
# @DESCRIPTION:
# Return truth if the current compiler enables stack smashing protection (SSP)
# on level corresponding to any of the following options:
#  -fstack-protector-all
tc-enables-ssp-all() {
	tc-cpp-is-true "defined(__SSP_ALL__)" ${CPPFLAGS} ${CFLAGS}
}


# @FUNCTION: gen_usr_ldscript
# @USAGE: [-a] <list of libs to create linker scripts for>
# @DESCRIPTION:
# This function is deprecated. Use the version from
# usr-ldscript.eclass instead.
gen_usr_ldscript() {
	ewarn "${FUNCNAME}: Please migrate to usr-ldscript.eclass"

	local lib libdir=$(get_libdir) output_format="" auto=false suffix=$(get_libname)
	[[ -z ${ED+set} ]] && local ED=${D%/}${EPREFIX}/

	tc-is-static-only && return

	# We only care about stuffing / for the native ABI. #479448
	if [[ $(type -t multilib_is_native_abi) == "function" ]] ; then
		multilib_is_native_abi || return 0
	fi

	# Eventually we'd like to get rid of this func completely #417451
	case ${CTARGET:-${CHOST}} in
	*-darwin*) ;;
	*-android*) return 0 ;;
	*linux*|*-freebsd*|*-openbsd*|*-netbsd*)
		use prefix && return 0 ;;
	*) return 0 ;;
	esac

	# Just make sure it exists
	dodir /usr/${libdir}

	if [[ $1 == "-a" ]] ; then
		auto=true
		shift
		dodir /${libdir}
	fi

	# OUTPUT_FORMAT gives hints to the linker as to what binary format
	# is referenced ... makes multilib saner
	local flags=( ${CFLAGS} ${LDFLAGS} -Wl,--verbose )
	if $(tc-getLD) --version | grep -q 'GNU gold' ; then
		# If they're using gold, manually invoke the old bfd. #487696
		local d="${T}/bfd-linker"
		mkdir -p "${d}"
		ln -sf $(which ${CHOST}-ld.bfd) "${d}"/ld
		flags+=( -B"${d}" )
	fi
	output_format=$($(tc-getCC) "${flags[@]}" 2>&1 | sed -n 's/^OUTPUT_FORMAT("\([^"]*\)",.*/\1/p')
	[[ -n ${output_format} ]] && output_format="OUTPUT_FORMAT ( ${output_format} )"

	for lib in "$@" ; do
		local tlib
		if ${auto} ; then
			lib="lib${lib}${suffix}"
		else
			# Ensure /lib/${lib} exists to avoid dangling scripts/symlinks.
			# This especially is for AIX where $(get_libname) can return ".a",
			# so /lib/${lib} might be moved to /usr/lib/${lib} (by accident).
			[[ -r ${ED}/${libdir}/${lib} ]] || continue
			#TODO: better die here?
		fi

		case ${CTARGET:-${CHOST}} in
		*-darwin*)
			if ${auto} ; then
				tlib=$(scanmacho -qF'%S#F' "${ED}"/usr/${libdir}/${lib})
			else
				tlib=$(scanmacho -qF'%S#F' "${ED}"/${libdir}/${lib})
			fi
			[[ -z ${tlib} ]] && die "unable to read install_name from ${lib}"
			tlib=${tlib##*/}

			if ${auto} ; then
				mv "${ED}"/usr/${libdir}/${lib%${suffix}}.*${suffix#.} "${ED}"/${libdir}/ || die
				# some install_names are funky: they encode a version
				if [[ ${tlib} != ${lib%${suffix}}.*${suffix#.} ]] ; then
					mv "${ED}"/usr/${libdir}/${tlib%${suffix}}.*${suffix#.} "${ED}"/${libdir}/ || die
				fi
				rm -f "${ED}"/${libdir}/${lib}
			fi

			# Mach-O files have an id, which is like a soname, it tells how
			# another object linking against this lib should reference it.
			# Since we moved the lib from usr/lib into lib this reference is
			# wrong.  Hence, we update it here.  We don't configure with
			# libdir=/lib because that messes up libtool files.
			# Make sure we don't lose the specific version, so just modify the
			# existing install_name
			if [[ ! -w "${ED}/${libdir}/${tlib}" ]] ; then
				chmod u+w "${ED}${libdir}/${tlib}" # needed to write to it
				local nowrite=yes
			fi
			install_name_tool \
				-id "${EPREFIX}"/${libdir}/${tlib} \
				"${ED}"/${libdir}/${tlib} || die "install_name_tool failed"
			[[ -n ${nowrite} ]] && chmod u-w "${ED}${libdir}/${tlib}"
			# Now as we don't use GNU binutils and our linker doesn't
			# understand linker scripts, just create a symlink.
			pushd "${ED}/usr/${libdir}" > /dev/null
			ln -snf "../../${libdir}/${tlib}" "${lib}"
			popd > /dev/null
			;;
		*)
			if ${auto} ; then
				tlib=$(scanelf -qF'%S#F' "${ED}"/usr/${libdir}/${lib})
				[[ -z ${tlib} ]] && die "unable to read SONAME from ${lib}"
				mv "${ED}"/usr/${libdir}/${lib}* "${ED}"/${libdir}/ || die
				# some SONAMEs are funky: they encode a version before the .so
				if [[ ${tlib} != ${lib}* ]] ; then
					mv "${ED}"/usr/${libdir}/${tlib}* "${ED}"/${libdir}/ || die
				fi
				rm -f "${ED}"/${libdir}/${lib}
			else
				tlib=${lib}
			fi
			cat > "${ED}/usr/${libdir}/${lib}" <<-END_LDSCRIPT
			/* GNU ld script
			   Since Gentoo has critical dynamic libraries in /lib, and the static versions
			   in /usr/lib, we need to have a "fake" dynamic lib in /usr/lib, otherwise we
			   run into linking problems.  This "fake" dynamic lib is a linker script that
			   redirects the linker to the real lib.  And yes, this works in the cross-
			   compiling scenario as the sysroot-ed linker will prepend the real path.

			   See bug https://bugs.gentoo.org/4411 for more info.
			 */
			${output_format}
			GROUP ( ${EPREFIX}/${libdir}/${tlib} )
			END_LDSCRIPT
			;;
		esac
		fperms a+x "/usr/${libdir}/${lib}" || die "could not change perms on ${lib}"
	done
}

fi
