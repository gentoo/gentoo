# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: flag-o-matic.eclass
# @MAINTAINER:
# toolchain@gentoo.org
# @BLURB: common functions to manipulate and query toolchain flags
# @DESCRIPTION:
# This eclass contains a suite of functions to help developers sanely
# and safely manage toolchain flags in their builds.

if [[ -z ${_FLAG_O_MATIC_ECLASS} ]]; then
_FLAG_O_MATIC_ECLASS=1

inherit eutils toolchain-funcs multilib

# Return all the flag variables that our high level funcs operate on.
all-flag-vars() {
	echo {ADA,C,CPP,CXX,CCAS,F,FC,LD}FLAGS
}

# {C,CPP,CXX,CCAS,F,FC,LD}FLAGS that we allow in strip-flags
# Note: shell globs and character lists are allowed
setup-allowed-flags() {
	ALLOWED_FLAGS=(
		-pipe -O '-O[12sg]' -mcpu -march -mtune
		'-fstack-protector*' '-fsanitize*' '-fstack-check*' -fno-stack-check
		-fbounds-check -fbounds-checking -fno-strict-overflow
		-fno-PIE -fno-pie -nopie -no-pie -fno-unit-at-a-time
		-g '-g[0-9]' -ggdb '-ggdb[0-9]' '-gdwarf-*' gstabs -gstabs+ -gz
		-fno-ident -fpermissive -frecord-gcc-switches
		'-fdiagnostics*' '-fplugin*'
		'-W*' -w

		# CPPFLAGS and LDFLAGS
		'-[DUILR]*' '-Wl,*'
	)

	# allow a bunch of flags that negate features / control ABI
	ALLOWED_FLAGS+=(
		'-fno-stack-protector*' '-fabi-version=*'
		-fno-strict-aliasing -fno-bounds-check -fno-bounds-checking -fstrict-overflow
		-fno-omit-frame-pointer '-fno-builtin*'
	)
	ALLOWED_FLAGS+=(
		-mregparm -mno-app-regs -mapp-regs -mno-mmx -mno-sse
		-mno-sse2 -mno-sse3 -mno-ssse3 -mno-sse4 -mno-sse4.1 -mno-sse4.2
		-mno-avx -mno-aes -mno-pclmul -mno-sse4a -mno-3dnow -mno-popcnt
		-mno-abm -mips1 -mips2 -mips3 -mips4 -mips32 -mips64 -mips16 -mplt
		-msoft-float -mno-soft-float -mhard-float -mno-hard-float -mfpu
		-mieee -mieee-with-inexact -mschedule -mfloat-gprs -mspe -mno-spe
		-mtls-direct-seg-refs -mno-tls-direct-seg-refs -mflat -mno-flat
		-mno-faster-structs -mfaster-structs -m32 -m64 -mx32 -mabi
		-mlittle-endian -mbig-endian -EL -EB -fPIC -mlive-g0 -mcmodel
		-mstack-bias -mno-stack-bias -msecure-plt '-m*-toc' -mfloat-abi
		-mfix-r10000 -mno-fix-r10000 -mthumb -marm

		# gcc 4.5
		-mno-fma4 -mno-movbe -mno-xop -mno-lwp
		# gcc 4.6
		-mno-fsgsbase -mno-rdrnd -mno-f16c -mno-bmi -mno-tbm
		# gcc 4.7
		-mno-avx2 -mno-bmi2 -mno-fma -mno-lzcnt
		# gcc 4.8
		-mno-fxsr -mno-hle -mno-rtm -mno-xsave -mno-xsaveopt
		# gcc 4.9
		-mno-avx512cd -mno-avx512er -mno-avx512f -mno-avx512pf -mno-sha
	)
}

# inverted filters for hardened compiler.  This is trying to unpick
# the hardened compiler defaults.
_filter-hardened() {
	local f
	for f in "$@" ; do
		case "${f}" in
			# Ideally we should only concern ourselves with PIE flags,
			# not -fPIC or -fpic, but too many places filter -fPIC without
			# thinking about -fPIE.
			-fPIC|-fpic|-fPIE|-fpie|-Wl,pie|-pie)
				gcc-specs-pie || continue
				if ! is-flagq -nopie && ! is-flagq -no-pie ; then
					# Support older Gentoo form first (-nopie) before falling
					# back to the official gcc-6+ form (-no-pie).
					if test-flags -nopie >/dev/null ; then
						append-flags -nopie
					else
						append-flags -no-pie
					fi
				fi
				;;
			-fstack-protector)
				gcc-specs-ssp || continue
				is-flagq -fno-stack-protector || append-flags $(test-flags -fno-stack-protector);;
			-fstack-protector-all)
				gcc-specs-ssp-to-all || continue
				is-flagq -fno-stack-protector-all || append-flags $(test-flags -fno-stack-protector-all);;
			-fno-strict-overflow)
				gcc-specs-nostrict || continue
				is-flagq -fstrict-overflow || append-flags $(test-flags -fstrict-overflow);;
		esac
	done
}

# Remove occurrences of strings from variable given in $1
# Strings removed are matched as globs, so for example
# '-O*' would remove -O1, -O2 etc.
_filter-var() {
	local f x var=$1 new=()
	shift

	for f in ${!var} ; do
		for x in "$@" ; do
			# Note this should work with globs like -O*
			[[ ${f} == ${x} ]] && continue 2
		done
		new+=( "${f}" )
	done
	export ${var}="${new[*]}"
}

# @FUNCTION: filter-flags
# @USAGE: <flags>
# @DESCRIPTION:
# Remove particular <flags> from {C,CPP,CXX,CCAS,F,FC,LD}FLAGS.  Accepts shell globs.
filter-flags() {
	_filter-hardened "$@"
	local v
	for v in $(all-flag-vars) ; do
		_filter-var ${v} "$@"
	done
	return 0
}

# @FUNCTION: filter-lfs-flags
# @DESCRIPTION:
# Remove flags that enable Large File Support.
filter-lfs-flags() {
	[[ $# -ne 0 ]] && die "filter-lfs-flags takes no arguments"
	# http://www.gnu.org/s/libc/manual/html_node/Feature-Test-Macros.html
	# _LARGEFILE_SOURCE: enable support for new LFS funcs (ftello/etc...)
	# _LARGEFILE64_SOURCE: enable support for 64bit variants (off64_t/fseeko64/etc...)
	# _FILE_OFFSET_BITS: default to 64bit variants (off_t is defined as off64_t)
	filter-flags -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE
}

# @FUNCTION: filter-ldflags
# @USAGE: <flags>
# @DESCRIPTION:
# Remove particular <flags> from LDFLAGS.  Accepts shell globs.
filter-ldflags() {
	_filter-var LDFLAGS "$@"
	return 0
}

# @FUNCTION: append-cppflags
# @USAGE: <flags>
# @DESCRIPTION:
# Add extra <flags> to the current CPPFLAGS.
append-cppflags() {
	[[ $# -eq 0 ]] && return 0
	export CPPFLAGS+=" $*"
	return 0
}

# @FUNCTION: append-cflags
# @USAGE: <flags>
# @DESCRIPTION:
# Add extra <flags> to the current CFLAGS.  If a flag might not be supported
# with different compilers (or versions), then use test-flags-CC like so:
# @CODE
# append-cflags $(test-flags-CC -funky-flag)
# @CODE
append-cflags() {
	[[ $# -eq 0 ]] && return 0
	# Do not do automatic flag testing ourselves. #417047
	export CFLAGS+=" $*"
	return 0
}

# @FUNCTION: append-cxxflags
# @USAGE: <flags>
# @DESCRIPTION:
# Add extra <flags> to the current CXXFLAGS.  If a flag might not be supported
# with different compilers (or versions), then use test-flags-CXX like so:
# @CODE
# append-cxxflags $(test-flags-CXX -funky-flag)
# @CODE
append-cxxflags() {
	[[ $# -eq 0 ]] && return 0
	# Do not do automatic flag testing ourselves. #417047
	export CXXFLAGS+=" $*"
	return 0
}

# @FUNCTION: append-fflags
# @USAGE: <flags>
# @DESCRIPTION:
# Add extra <flags> to the current {F,FC}FLAGS.  If a flag might not be supported
# with different compilers (or versions), then use test-flags-F77 like so:
# @CODE
# append-fflags $(test-flags-F77 -funky-flag)
# @CODE
append-fflags() {
	[[ $# -eq 0 ]] && return 0
	# Do not do automatic flag testing ourselves. #417047
	export FFLAGS+=" $*"
	export FCFLAGS+=" $*"
	return 0
}

# @FUNCTION: append-lfs-flags
# @DESCRIPTION:
# Add flags that enable Large File Support.
append-lfs-flags() {
	[[ $# -ne 0 ]] && die "append-lfs-flags takes no arguments"
	# see comments in filter-lfs-flags func for meaning of these
	append-cppflags -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE
}

# @FUNCTION: append-ldflags
# @USAGE: <flags>
# @DESCRIPTION:
# Add extra <flags> to the current LDFLAGS.
append-ldflags() {
	[[ $# -eq 0 ]] && return 0
	local flag
	for flag in "$@"; do
		[[ ${flag} == -l* ]] && \
			eqawarn "Appending a library link instruction (${flag}); libraries to link to should not be passed through LDFLAGS"
	done

	export LDFLAGS="${LDFLAGS} $*"
	return 0
}

# @FUNCTION: append-flags
# @USAGE: <flags>
# @DESCRIPTION:
# Add extra <flags> to your current {C,CXX,F,FC}FLAGS.
append-flags() {
	[[ $# -eq 0 ]] && return 0
	case " $* " in
	*' '-[DIU]*) eqawarn 'please use append-cppflags for preprocessor flags' ;;
	*' '-L*|\
	*' '-Wl,*)  eqawarn 'please use append-ldflags for linker flags' ;;
	esac
	append-cflags "$@"
	append-cxxflags "$@"
	append-fflags "$@"
	return 0
}

# @FUNCTION: replace-flags
# @USAGE: <old> <new>
# @DESCRIPTION:
# Replace the <old> flag with <new>.  Accepts shell globs for <old>.
replace-flags() {
	[[ $# != 2 ]] && die "Usage: replace-flags <old flag> <new flag>"

	local f var new
	for var in $(all-flag-vars) ; do
		# Looping over the flags instead of using a global
		# substitution ensures that we're working with flag atoms.
		# Otherwise globs like -O* have the potential to wipe out the
		# list of flags.
		new=()
		for f in ${!var} ; do
			# Note this should work with globs like -O*
			[[ ${f} == ${1} ]] && f=${2}
			new+=( "${f}" )
		done
		export ${var}="${new[*]}"
	done

	return 0
}

# @FUNCTION: replace-cpu-flags
# @USAGE: <old> <new>
# @DESCRIPTION:
# Replace cpu flags (like -march/-mcpu/-mtune) that select the <old> cpu
# with flags that select the <new> cpu.  Accepts shell globs for <old>.
replace-cpu-flags() {
	local newcpu="$#" ; newcpu="${!newcpu}"
	while [ $# -gt 1 ] ; do
		# quote to make sure that no globbing is done (particularly on
		# ${oldcpu}) prior to calling replace-flags
		replace-flags "-march=${1}" "-march=${newcpu}"
		replace-flags "-mcpu=${1}" "-mcpu=${newcpu}"
		replace-flags "-mtune=${1}" "-mtune=${newcpu}"
		shift
	done
	return 0
}

_is_flagq() {
	local x var="$1[*]"
	for x in ${!var} ; do
		[[ ${x} == $2 ]] && return 0
	done
	return 1
}

# @FUNCTION: is-flagq
# @USAGE: <flag>
# @DESCRIPTION:
# Returns shell true if <flag> is in {C,CXX,F,FC}FLAGS, else returns shell false.  Accepts shell globs.
is-flagq() {
	[[ -n $2 ]] && die "Usage: is-flag <flag>"

	local var
	for var in $(all-flag-vars) ; do
		_is_flagq ${var} "$1" && return 0
	done
	return 1
}

# @FUNCTION: is-flag
# @USAGE: <flag>
# @DESCRIPTION:
# Echo's "true" if flag is set in {C,CXX,F,FC}FLAGS.  Accepts shell globs.
is-flag() {
	is-flagq "$@" && echo true
}

# @FUNCTION: is-ldflagq
# @USAGE: <flag>
# @DESCRIPTION:
# Returns shell true if <flag> is in LDFLAGS, else returns shell false.  Accepts shell globs.
is-ldflagq() {
	[[ -n $2 ]] && die "Usage: is-ldflag <flag>"
	_is_flagq LDFLAGS $1
}

# @FUNCTION: is-ldflag
# @USAGE: <flag>
# @DESCRIPTION:
# Echo's "true" if flag is set in LDFLAGS.  Accepts shell globs.
is-ldflag() {
	is-ldflagq "$@" && echo true
}

# @FUNCTION: filter-mfpmath
# @USAGE: <math types>
# @DESCRIPTION:
# Remove specified math types from the fpmath flag.  For example, if the user
# has -mfpmath=sse,386, running `filter-mfpmath sse` will leave the user with
# -mfpmath=386.
filter-mfpmath() {
	local orig_mfpmath new_math prune_math

	# save the original -mfpmath flag
	orig_mfpmath=$(get-flag -mfpmath)
	# get the value of the current -mfpmath flag
	new_math=$(get-flag mfpmath)
	# convert "both" to something we can filter
	new_math=${new_math/both/387,sse}
	new_math=" ${new_math//[,+]/ } "
	# figure out which math values are to be removed
	prune_math=""
	for prune_math in "$@" ; do
		new_math=${new_math/ ${prune_math} / }
	done
	new_math=$(echo ${new_math})
	new_math=${new_math// /,}

	if [[ -z ${new_math} ]] ; then
		# if we're removing all user specified math values are
		# slated for removal, then we just filter the flag
		filter-flags ${orig_mfpmath}
	else
		# if we only want to filter some of the user specified
		# math values, then we replace the current flag
		replace-flags ${orig_mfpmath} -mfpmath=${new_math}
	fi
	return 0
}

# @FUNCTION: strip-flags
# @DESCRIPTION:
# Strip *FLAGS of everything except known good/safe flags.  This runs over all
# flags returned by all_flag_vars().
strip-flags() {
	local x y var

	local ALLOWED_FLAGS
	setup-allowed-flags

	set -f	# disable pathname expansion

	for var in $(all-flag-vars) ; do
		local new=()

		for x in ${!var} ; do
			local flag=${x%%=*}
			for y in "${ALLOWED_FLAGS[@]}" ; do
				if [[ -z ${flag%%${y}} ]] ; then
					new+=( "${x}" )
					break
				fi
			done
		done

		# In case we filtered out all optimization flags fallback to -O2
		if _is_flagq ${var} "-O*" && ! _is_flagq new "-O*" ; then
			new+=( -O2 )
		fi

		if [[ ${!var} != "${new[*]}" ]] ; then
			einfo "strip-flags: ${var}: changed '${!var}' to '${new[*]}'"
		fi
		export ${var}="${new[*]}"
	done

	set +f	# re-enable pathname expansion

	return 0
}

test-flag-PROG() {
	local comp=$1
	local lang=$2
	local flag=$3

	[[ -z ${comp} || -z ${flag} ]] && return 1

	local cmdline=(
		$(tc-get${comp})
		# Clang will warn about unknown gcc flags but exit 0.
		# Need -Werror to force it to exit non-zero.
		-Werror
		# Use -c so we can test the assembler as well.
		-c -o /dev/null
	)
	if "${cmdline[@]}" -x${lang} - </dev/null &>/dev/null ; then
		cmdline+=( "${flag}" -x${lang} - )
	else
		# XXX: what's the purpose of this? does it even work with
		# any compiler?
		cmdline+=( "${flag}" -c -o /dev/null /dev/null )
	fi

	if ! "${cmdline[@]}" </dev/null &>/dev/null; then
		# -Werror makes clang bail out on unused arguments as well;
		# try to add -Qunused-arguments to work-around that
		# other compilers don't support it but then, it's failure like
		# any other
		cmdline+=( -Qunused-arguments )
		"${cmdline[@]}" </dev/null &>/dev/null
	fi
}

# @FUNCTION: test-flag-CC
# @USAGE: <flag>
# @DESCRIPTION:
# Returns shell true if <flag> is supported by the C compiler, else returns shell false.
test-flag-CC() { test-flag-PROG "CC" c "$1"; }

# @FUNCTION: test-flag-CXX
# @USAGE: <flag>
# @DESCRIPTION:
# Returns shell true if <flag> is supported by the C++ compiler, else returns shell false.
test-flag-CXX() { test-flag-PROG "CXX" c++ "$1"; }

# @FUNCTION: test-flag-F77
# @USAGE: <flag>
# @DESCRIPTION:
# Returns shell true if <flag> is supported by the Fortran 77 compiler, else returns shell false.
test-flag-F77() { test-flag-PROG "F77" f77 "$1"; }

# @FUNCTION: test-flag-FC
# @USAGE: <flag>
# @DESCRIPTION:
# Returns shell true if <flag> is supported by the Fortran 90 compiler, else returns shell false.
test-flag-FC() { test-flag-PROG "FC" f95 "$1"; }

test-flags-PROG() {
	local comp=$1
	local flags=()
	local x

	shift

	[[ -z ${comp} ]] && return 1

	for x ; do
		test-flag-${comp} "${x}" && flags+=( "${x}" )
	done

	echo "${flags[*]}"

	# Just bail if we dont have any flags
	[[ ${#flags[@]} -gt 0 ]]
}

# @FUNCTION: test-flags-CC
# @USAGE: <flags>
# @DESCRIPTION:
# Returns shell true if <flags> are supported by the C compiler, else returns shell false.
test-flags-CC() { test-flags-PROG "CC" "$@"; }

# @FUNCTION: test-flags-CXX
# @USAGE: <flags>
# @DESCRIPTION:
# Returns shell true if <flags> are supported by the C++ compiler, else returns shell false.
test-flags-CXX() { test-flags-PROG "CXX" "$@"; }

# @FUNCTION: test-flags-F77
# @USAGE: <flags>
# @DESCRIPTION:
# Returns shell true if <flags> are supported by the Fortran 77 compiler, else returns shell false.
test-flags-F77() { test-flags-PROG "F77" "$@"; }

# @FUNCTION: test-flags-FC
# @USAGE: <flags>
# @DESCRIPTION:
# Returns shell true if <flags> are supported by the Fortran 90 compiler, else returns shell false.
test-flags-FC() { test-flags-PROG "FC" "$@"; }

# @FUNCTION: test-flags
# @USAGE: <flags>
# @DESCRIPTION:
# Short-hand that should hopefully work for both C and C++ compiler, but
# its really only present due to the append-flags() abomination.
test-flags() { test-flags-CC "$@"; }

# @FUNCTION: test_version_info
# @USAGE: <version>
# @DESCRIPTION:
# Returns shell true if the current C compiler version matches <version>, else returns shell false.
# Accepts shell globs.
test_version_info() {
	if [[ $($(tc-getCC) --version 2>&1) == *$1* ]]; then
		return 0
	else
		return 1
	fi
}

# @FUNCTION: strip-unsupported-flags
# @DESCRIPTION:
# Strip {C,CXX,F,FC}FLAGS of any flags not supported by the active toolchain.
strip-unsupported-flags() {
	export CFLAGS=$(test-flags-CC ${CFLAGS})
	export CXXFLAGS=$(test-flags-CXX ${CXXFLAGS})
	export FFLAGS=$(test-flags-F77 ${FFLAGS})
	export FCFLAGS=$(test-flags-FC ${FCFLAGS})
	# note: this does not verify the linker flags but it is enough
	# to strip invalid C flags which are much more likely, #621274
	export LDFLAGS=$(test-flags-CC ${LDFLAGS})
}

# @FUNCTION: get-flag
# @USAGE: <flag>
# @DESCRIPTION:
# Find and echo the value for a particular flag.  Accepts shell globs.
get-flag() {
	local f var findflag="$1"

	# this code looks a little flaky but seems to work for
	# everything we want ...
	# for example, if CFLAGS="-march=i686":
	# `get-flag -march` == "-march=i686"
	# `get-flag march` == "i686"
	for var in $(all-flag-vars) ; do
		for f in ${!var} ; do
			if [ "${f/${findflag}}" != "${f}" ] ; then
				printf "%s\n" "${f/-${findflag}=}"
				return 0
			fi
		done
	done
	return 1
}

has_m64() {
	die "${FUNCNAME}: don't use this anymore"
}

has_m32() {
	die "${FUNCNAME}: don't use this anymore"
}

# @FUNCTION: replace-sparc64-flags
# @DESCRIPTION:
# Sets mcpu to v8 and uses the original value as mtune if none specified.
replace-sparc64-flags() {
	local SPARC64_CPUS="ultrasparc3 ultrasparc v9"

	if [ "${CFLAGS/mtune}" != "${CFLAGS}" ]; then
		for x in ${SPARC64_CPUS}; do
			CFLAGS="${CFLAGS/-mcpu=${x}/-mcpu=v8}"
		done
	else
		for x in ${SPARC64_CPUS}; do
			CFLAGS="${CFLAGS/-mcpu=${x}/-mcpu=v8 -mtune=${x}}"
		done
	fi

	if [ "${CXXFLAGS/mtune}" != "${CXXFLAGS}" ]; then
		for x in ${SPARC64_CPUS}; do
			CXXFLAGS="${CXXFLAGS/-mcpu=${x}/-mcpu=v8}"
		done
	else
		for x in ${SPARC64_CPUS}; do
			CXXFLAGS="${CXXFLAGS/-mcpu=${x}/-mcpu=v8 -mtune=${x}}"
		done
	fi

	export CFLAGS CXXFLAGS
}

# @FUNCTION: append-libs
# @USAGE: <libs>
# @DESCRIPTION:
# Add extra <libs> to the current LIBS. All arguments should be prefixed with
# either -l or -L.  For compatibility, if arguments are not prefixed as
# options, they are given a -l prefix automatically.
append-libs() {
	[[ $# -eq 0 ]] && return 0
	local flag
	for flag in "$@"; do
		if [[ -z "${flag// }" ]]; then
			eqawarn "Appending an empty argument to LIBS is invalid! Skipping."
			continue
		fi
		case $flag in
			-[lL]*)
				export LIBS="${LIBS} ${flag}"
				;;
			-*)
				eqawarn "Appending non-library to LIBS (${flag}); Other linker flags should be passed via LDFLAGS"
				export LIBS="${LIBS} ${flag}"
				;;
			*)
				export LIBS="${LIBS} -l${flag}"
		esac
	done

	return 0
}

# @FUNCTION: raw-ldflags
# @USAGE: [flags]
# @DESCRIPTION:
# Turn C style ldflags (-Wl,-foo) into straight ldflags - the results
# are suitable for passing directly to 'ld'; note LDFLAGS is usually passed
# to gcc where it needs the '-Wl,'.
#
# If no flags are specified, then default to ${LDFLAGS}.
raw-ldflags() {
	local x input="$@"
	[[ -z ${input} ]] && input=${LDFLAGS}
	set --
	for x in ${input} ; do
		case ${x} in
		-Wl,*)
			x=${x#-Wl,}
			set -- "$@" ${x//,/ }
			;;
		*)	# Assume it's a compiler driver flag, so throw it away #441808
			;;
		esac
	done
	echo "$@"
}

# @FUNCTION: no-as-needed
# @RETURN: Flag to disable asneeded behavior for use with append-ldflags.
no-as-needed() {
	case $($(tc-getLD) -v 2>&1 </dev/null) in
		*GNU*) # GNU ld
		echo "-Wl,--no-as-needed" ;;
	esac
}

fi
