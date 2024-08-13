# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: flag-o-matic.eclass
# @MAINTAINER:
# toolchain@gentoo.org
# @SUPPORTED_EAPIS: 6 7 8
# @BLURB: common functions to manipulate and query toolchain flags
# @DESCRIPTION:
# This eclass contains a suite of functions to help developers sanely
# and safely manage toolchain flags in their builds.

case ${EAPI} in
	6|7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_FLAG_O_MATIC_ECLASS} ]]; then
_FLAG_O_MATIC_ECLASS=1

inherit toolchain-funcs

[[ ${EAPI} == 6 ]] && inherit eqawarn

# @FUNCTION: all-flag-vars
# @DESCRIPTION:
# Return all the flag variables that our high level functions operate on.
all-flag-vars() {
	echo {ADA,C,CPP,CXX,CCAS,F,FC,LD}FLAGS
}

# @FUNCTION: setup-allowed-flags
# @INTERNAL
# @DESCRIPTION:
# {C,CPP,CXX,CCAS,F,FC,LD}FLAGS that we allow in strip-flags
# Note: shell globs and character lists are allowed
setup-allowed-flags() {
	[[ ${EAPI} == [67] ]] ||
		die "Internal function ${FUNCNAME} is not available in EAPI ${EAPI}."
	_setup-allowed-flags "$@"
}

# @FUNCTION: _setup-allowed-flags
# @INTERNAL
# @DESCRIPTION:
# {C,CPP,CXX,CCAS,F,FC,LD}FLAGS that we allow in strip-flags
# Note: shell globs and character lists are allowed
_setup-allowed-flags() {
	ALLOWED_FLAGS=(
		-pipe -O '-O[123szg]' '-mcpu=*' '-march=*' '-mtune=*' '-mfpmath=*'
		-flto '-flto=*' -fno-lto

		# Hardening flags
		'-fstack-protector*'
		-fstack-clash-protection
		'-fcf-protection=*'
		-fbounds-check -fbounds-checking
		-fno-PIE -fno-pie -nopie -no-pie
		-fharden-compares -fharden-conditional-branches
		-fharden-control-flow-redundancy -fno-harden-control-flow-redundancy
		-fhardcfr-skip-leaf -fhardcfr-check-exceptions -fhardcfr-check-returning-calls
		'-fhardcfr-check-noreturn-calls=*'
		# Spectre mitigations, bug #646076
		'-mindirect-branch=*'
		-mindirect-branch-register
		'-mfunction-return=*'
		-mretpoline
		'-mharden-sls=*'
		'-mbranch-protection=*'

		# Misc
		-fno-unit-at-a-time -fno-strict-overflow

		# Sanitizers
		'-fsanitize*' '-fno-sanitize*'

		# Debugging symbols should generally be very safe to add
		-g '-g[0-9]'
		-ggdb '-ggdb[0-9]'
		-gdwarf '-gdwarf-*'
		-gstabs -gstabs+
		-gz
		-glldb
		'-fdebug-default-version=*'

		# Cosmetic/output related, see e.g. bug #830534
		-fno-diagnostics-color '-fmessage-length=*'
		-fno-ident -fpermissive -frecord-gcc-switches
		-frecord-command-line
		'-fdiagnostics*' '-fplugin*'
		'-W*' -w

		# CPPFLAGS and LDFLAGS
		'-[DUILR]*' '-Wl,*'

		# Linker choice flag
		'-fuse-ld=*'
	)

	# allow a bunch of flags that negate features / control ABI
	ALLOWED_FLAGS+=(
		'-fno-stack-protector*' '-fabi-version=*'
		-fno-strict-aliasing -fno-bounds-check -fno-bounds-checking -fstrict-overflow
		-fno-omit-frame-pointer '-fno-builtin*'
		-mno-omit-leaf-frame-pointer
	)
	ALLOWED_FLAGS+=(
		'-mregparm=*' -mno-app-regs -mapp-regs -mno-mmx -mno-sse
		-mno-sse2 -mno-sse3 -mno-ssse3 -mno-sse4 -mno-sse4.1 -mno-sse4.2
		-mno-avx -mno-aes -mno-pclmul -mno-sse4a -mno-3dnow -mno-popcnt
		-mno-abm -mips1 -mips2 -mips3 -mips4 -mips32 -mips64 -mips16 -mplt
		-msoft-float -mno-soft-float -mhard-float -mno-hard-float '-mfpu=*'
		-mieee -mieee-with-inexact '-mschedule=*' -mfloat-gprs -mspe -mno-spe
		-mtls-direct-seg-refs -mno-tls-direct-seg-refs -mflat -mno-flat
		-mno-faster-structs -mfaster-structs -m32 -m64 -mx32 '-mabi=*'
		-mlittle-endian -mbig-endian -EL -EB -fPIC -mlive-g0 '-mcmodel=*'
		-mstack-bias -mno-stack-bias -msecure-plt '-m*-toc' '-mfloat-abi=*'

		# This is default on for a bunch of arches except amd64 in GCC
		# already, and amd64 itself is planned too.
		'-mtls-dialect=*'

		# MIPS errata
		-mfix-r4000 -mno-fix-r4000 -mfix-r4400 -mno-fix-r4400
		-mfix-r10000 -mno-fix-r10000

		'-mr10k-cache-barrier=*' -mthumb -marm

		# needed for arm64 (and in particular SCS)
		-ffixed-x18

		# needed for riscv (to prevent unaligned vector access)
		# See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=115789
		-mstrict-align -mvector-strict-align

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

		-mevex512 -mno-evex512
	)

	# Allow some safe individual flags. Should come along with the bug reference.
	ALLOWED_FLAGS+=(
		# Allow explicit stack realignment to run non-conformant
		# binaries: bug #677852
		-mstackrealign
		'-mpreferred-stack-boundary=*'
		'-mincoming-stack-boundary=*'
	)
	ALLOWED_FLAGS+=(
		# Clang-only
		'--unwindlib=*'
		'--rtlib=*'
		'--stdlib=*'
	)
}

# @FUNCTION: _filter-hardened
# @INTERNAL
# @DESCRIPTION:
# Inverted filters for hardened compiler.  This is trying to unpick
# the hardened compiler defaults.
_filter-hardened() {
	local f
	for f in "$@" ; do
		case "${f}" in
			# Ideally we should only concern ourselves with PIE flags,
			# not -fPIC or -fpic, but too many places filter -fPIC without
			# thinking about -fPIE.
			-fPIC|-fpic|-fPIE|-fpie|-Wl,pie|-pie)
				if ! gcc-specs-pie && ! tc-enables-pie ; then
					continue
				fi

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

			-fstack-protector|-fstack-protector-strong)
				if ! gcc-specs-ssp && ! tc-enables-ssp && ! tc-enables-ssp-strong ; then
					continue
				fi

				is-flagq -fno-stack-protector || append-flags $(test-flags -fno-stack-protector)
				;;
			-fstack-protector-all)
				if ! gcc-specs-ssp-to-all && ! tc-enables-ssp-all ; then
					continue
				fi

				is-flagq -fno-stack-protector-all || append-flags $(test-flags -fno-stack-protector-all)
				;;
			-fno-strict-overflow)
				gcc-specs-nostrict || continue

				is-flagq -fstrict-overflow || append-flags $(test-flags -fstrict-overflow)
				;;
			-D_GLIBCXX_ASSERTIONS|-D_LIBCPP_ENABLE_ASSERTIONS|-D_LIBCPP_ENABLE_HARDENED_MODE)
				tc-enables-cxx-assertions || continue

				append-cppflags -U_GLIBCXX_ASSERTIONS -U_LIBCPP_ENABLE_ASSERTIONS -U_LIBCPP_ENABLE_HARDENED_MODE
				;;
			-D_FORTIFY_SOURCE=*)
				tc-enables-fortify-source || continue

				append-cppflags -U_FORTIFY_SOURCE
				;;
		esac
	done
}

# @FUNCTION: _filter-var
# @INTERNAL
# @DESCRIPTION:
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
	# _TIME_BITS: default to 64bit time_t (requires _FILE_OFFSET_BITS=64)
	filter-flags -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_TIME_BITS=64
}

# @FUNCTION: filter-lto
# @DESCRIPTION:
# Remove flags that enable LTO and those that depend on it
filter-lto() {
	[[ $# -ne 0 ]] && die "filter-lto takes no arguments"
	filter-flags '-flto*' -fvirtual-function-elimination -fwhole-program-vtables '-fsanitize=cfi*'
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
	# Do not do automatic flag testing ourselves, bug #417047
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
	# Do not do automatic flag testing ourselves, bug #417047
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
	# Do not do automatic flag testing ourselves, bug #417047
	export FFLAGS+=" $*"
	export FCFLAGS+=" $*"
	return 0
}

# @FUNCTION: append-lfs-flags
# @DESCRIPTION:
# Add flags that enable Large File Support.
append-lfs-flags() {
	[[ $# -ne 0 ]] && die "append-lfs-flags takes no arguments"

	# See comments in filter-lfs-flags func for meaning of these
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
	*' '-[DIU]*) eqawarn 'Please use append-cppflags for preprocessor flags' ;;
	*' '-L*|\
	*' '-Wl,*)  eqawarn 'Please use append-ldflags for linker flags' ;;
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

# @FUNCTION: _is_flagq
# @USAGE: <variable> <flag>
# @INTERNAL
# @DESCRIPTION:
# Returns shell true if <flag> is in a given <variable>, else returns shell false.
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
	[[ $# -ne 0 ]] && die "strip-flags takes no arguments"
	local x y var

	local ALLOWED_FLAGS
	_setup-allowed-flags

	set -f	# disable pathname expansion

	for var in $(all-flag-vars) ; do
		local new=()

		for x in ${!var} ; do
			for y in "${ALLOWED_FLAGS[@]}" ; do
				if [[ ${x} == ${y} ]] ; then
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

# @FUNCTION: test-flag-PROG
# @USAGE: <compiler> <flag>
# @INTERNAL
# @DESCRIPTION:
# Returns shell true if <flag> is supported by given <compiler>,
# else returns shell false.
test-flag-PROG() {
	[[ ${EAPI} == [67] ]] ||
		die "Internal function ${FUNCNAME} is not available in EAPI ${EAPI}."
	_test-flag-PROG "$@"
}

# @FUNCTION: _test-flag-PROG
# @USAGE: <compiler> <flag>
# @INTERNAL
# @DESCRIPTION:
# Returns shell true if <flag> is supported by given <compiler>,
# else returns shell false.
_test-flag-PROG() {
	local comp=$1
	local lang=$2
	shift 2

	if [[ -z ${comp} ]]; then
		return 1
	fi
	if [[ -z $1 ]]; then
		return 1
	fi

	# verify selected compiler exists before using it
	comp=($(tc-get${comp}))
	# 'comp' can already contain compiler options.
	# 'type' needs a binary name
	if ! type -p ${comp[0]} >/dev/null; then
		return 1
	fi

	# Set up test file.
	local in_src in_ext cmdline_extra=()
	case "${lang}" in
		# compiler/assembler only
		c)
			in_ext='c'
			in_src='int main(void) { return 0; }'
			cmdline_extra+=(-xc -c)
			;;
		c++)
			in_ext='cc'
			in_src='int main(void) { return 0; }'
			cmdline_extra+=(-xc++ -c)
			;;
		f77)
			in_ext='f'
			# fixed source form
			in_src='      end'
			cmdline_extra+=(-xf77 -c)
			;;
		f95)
			in_ext='f90'
			in_src='end'
			cmdline_extra+=(-xf95 -c)
			;;

		# C compiler/assembler/linker
		c+ld)
			in_ext='c'
			in_src='int main(void) { return 0; }'

			if is-ldflagq -fuse-ld=* ; then
				# Respect linker chosen by user so we don't
				# end up giving false results by checking
				# with default linker. bug #832377
				fuse_ld_value=$(get-flag -fuse-ld=*)
				cmdline_extra+=(${fuse_ld_value})
			fi

			cmdline_extra+=(-xc)
			;;
	esac
	local test_in=${T}/test-flag.${in_ext}
	local test_out=${T}/test-flag.exe

	printf "%s\n" "${in_src}" > "${test_in}" || die "Failed to create '${test_in}'"

	# Currently we rely on warning-free output of a compiler
	# before the flag to see if a flag produces any warnings.
	# This has a few drawbacks:
	# - if compiler already generates warnings we filter out
	#   every single flag: bug #712488
	# - if user actually wants to see warnings we just strip
	#   them regardless of warnings type.
	#
	# We can add more selective detection of no-op flags via
	# '-Werror=ignored-optimization-argument' and similar error options
	# or accept unused flags with '-Qunused-arguments' like we
	# used to for bug #627474. Since we now invoke the linker
	# for testing linker flags, unused argument warnings aren't
	# ignored; linker flags may no longer be accepted in CFLAGS.
	#
	# However, warnings emitted by a compiler for a clean source
	# can break feature detection by CMake or autoconf since
	# many checks use -Werror internally. See e.g. bug #714742.
	local cmdline=(
		"${comp[@]}"
		# Clang will warn about unknown gcc flags but exit 0.
		# Need -Werror to force it to exit non-zero.
		#
		# See also bug #712488 and bug #714742.
		-Werror
		"$@"
		# -x<lang> options need to go before first source file
		"${cmdline_extra[@]}"

		"${test_in}" -o "${test_out}"
	)

	"${cmdline[@]}" &>/dev/null
}

# @FUNCTION: test-flag-CC
# @USAGE: <flag>
# @DESCRIPTION:
# Returns shell true if <flag> is supported by the C compiler, else returns shell false.
test-flag-CC() { _test-flag-PROG CC c "$@"; }

# @FUNCTION: test-flag-CXX
# @USAGE: <flag>
# @DESCRIPTION:
# Returns shell true if <flag> is supported by the C++ compiler, else returns shell false.
test-flag-CXX() { _test-flag-PROG CXX c++ "$@"; }

# @FUNCTION: test-flag-F77
# @USAGE: <flag>
# @DESCRIPTION:
# Returns shell true if <flag> is supported by the Fortran 77 compiler, else returns shell false.
test-flag-F77() { _test-flag-PROG F77 f77 "$@"; }

# @FUNCTION: test-flag-FC
# @USAGE: <flag>
# @DESCRIPTION:
# Returns shell true if <flag> is supported by the Fortran 90 compiler, else returns shell false.
test-flag-FC() { _test-flag-PROG FC f95 "$@"; }

# @FUNCTION: test-flag-CCLD
# @USAGE: <flag>
# @DESCRIPTION:
# Returns shell true if <flag> is supported by the C compiler and linker, else returns shell false.
test-flag-CCLD() { _test-flag-PROG CC c+ld "$@"; }

# @FUNCTION: test-flags-PROG
# @USAGE: <compiler> <flag> [more flags...]
# @INTERNAL
# @DESCRIPTION:
# Returns shell true if <flags> are supported by given <compiler>,
# else returns shell false.
test-flags-PROG() {
	[[ ${EAPI} == [67] ]] ||
		die "Internal function ${FUNCNAME} is not available in EAPI ${EAPI}."
	_test-flags-PROG "$@"
}

# @FUNCTION: _test-flags-PROG
# @USAGE: <compiler> <flag> [more flags...]
# @INTERNAL
# @DESCRIPTION:
# Returns shell true if <flags> are supported by given <compiler>,
# else returns shell false.
_test-flags-PROG() {
	local comp=$1
	local flags=()
	local x

	shift

	[[ -z ${comp} ]] && return 1

	while (( $# )); do
		case "$1" in
			# '-B /foo': bug #687198
			--param|-B)
				if test-flag-${comp} "$1" "$2"; then
					flags+=( "$1" "$2" )
				fi
				shift 2
				;;
			*)
				if test-flag-${comp} "$1"; then
					flags+=( "$1" )
				fi
				shift 1
				;;
		esac
	done

	echo "${flags[*]}"

	# Just bail if we dont have any flags
	[[ ${#flags[@]} -gt 0 ]]
}

# @FUNCTION: test-flags-CC
# @USAGE: <flags>
# @DESCRIPTION:
# Returns shell true if <flags> are supported by the C compiler, else returns shell false.
test-flags-CC() { _test-flags-PROG CC "$@"; }

# @FUNCTION: test-flags-CXX
# @USAGE: <flags>
# @DESCRIPTION:
# Returns shell true if <flags> are supported by the C++ compiler, else returns shell false.
test-flags-CXX() { _test-flags-PROG CXX "$@"; }

# @FUNCTION: test-flags-F77
# @USAGE: <flags>
# @DESCRIPTION:
# Returns shell true if <flags> are supported by the Fortran 77 compiler, else returns shell false.
test-flags-F77() { _test-flags-PROG F77 "$@"; }

# @FUNCTION: test-flags-FC
# @USAGE: <flags>
# @DESCRIPTION:
# Returns shell true if <flags> are supported by the Fortran 90 compiler, else returns shell false.
test-flags-FC() { _test-flags-PROG FC "$@"; }

# @FUNCTION: test-flags-CCLD
# @USAGE: <flags>
# @DESCRIPTION:
# Returns shell true if <flags> are supported by the C compiler and default linker, else returns shell false.
test-flags-CCLD() { _test-flags-PROG CCLD "$@"; }

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
	[[ $# -ne 0 ]] && die "strip-unsupported-flags takes no arguments"
	export CFLAGS=$(test-flags-CC ${CFLAGS})
	export CXXFLAGS=$(test-flags-CXX ${CXXFLAGS})
	export FFLAGS=$(test-flags-F77 ${FFLAGS})
	export FCFLAGS=$(test-flags-FC ${FCFLAGS})
	export LDFLAGS=$(test-flags-CCLD ${LDFLAGS})
}

# @FUNCTION: get-flag
# @USAGE: <flag>
# @DESCRIPTION:
# Find and echo the value for a particular flag.  Accepts shell globs.
get-flag() {
	[[ $# -ne 1 ]] && die "usage: <flag>"
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

# @FUNCTION: replace-sparc64-flags
# @DESCRIPTION:
# Sets mcpu to v8 and uses the original value as mtune if none specified.
replace-sparc64-flags() {
	[[ $# -ne 0 ]] && die "replace-sparc64-flags takes no arguments"
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
		*)	# Assume it's a compiler driver flag, so throw it away, bug #441808
			;;
		esac
	done
	echo "$@"
}

# @FUNCTION: no-as-needed
# @RETURN: Flag to disable asneeded behavior for use with append-ldflags.
no-as-needed() {
	[[ $# -ne 0 ]] && die "no-as-needed takes no arguments"
	case $($(tc-getLD) -v 2>&1 </dev/null) in
		*GNU*) # GNU ld
		echo "-Wl,--no-as-needed" ;;
	esac
}

# @FUNCTION: test-compile
# @USAGE: <language> <code>
# @DESCRIPTION:
# Attempts to compile (and possibly link) the given program.  The first
# <language> parameter corresponds to the standard -x compiler argument.
# If the program should additionally be attempted to be linked, the string
# "+ld" should be added to the <language> parameter.
test-compile() {
	local lang=$1
	local code=$2
	shift 2

	[[ -z "${lang}" ]] && return 1
	[[ -z "${code}" ]] && return 1

	local compiler filename_in filename_out args=() libs=()
	case "${lang}" in
		c)
			compiler="$(tc-getCC)"
			filename_in="${T}/test.c"
			filename_out="${T}/test.o"
			args+=(${CFLAGS[@]} -xc -c)
			;;
		c++)
			compiler="$(tc-getCXX)"
			filename_in="${T}/test.cc"
			filename_out="${T}/test.o"
			args+=(${CXXFLAGS[@]} -xc++ -c)
			;;
		f77)
			compiler="$(tc-getF77)"
			filename_in="${T}/test.f"
			filename_out="${T}/test.o"
			args+=(${FFFLAGS[@]} -xf77 -c)
			;;
		f95)
			compiler="$(tc-getFC)"
			filename_in="${T}/test.f90"
			filename_out="${T}/test.o"
			args+=(${FCFLAGS[@]} -xf95 -c)
			;;
		c+ld)
			compiler="$(tc-getCC)"
			filename_in="${T}/test.c"
			filename_out="${T}/test.exe"
			args+=(${CFLAGS[@]} ${LDFLAGS[@]} -xc)
			libs+=(${LIBS[@]})
			;;
		c+++ld)
			compiler="$(tc-getCXX)"
			filename_in="${T}/test.cc"
			filename_out="${T}/test.exe"
			args+=(${CXXFLAGS[@]} ${LDFLAGS[@]} -xc++)
			libs+=(${LIBS[@]})
			;;
		f77+ld)
			compiler="$(tc-getF77)"
			filename_in="${T}/test.f"
			filename_out="${T}/test.exe"
			args+=(${FFLAGS[@]} ${LDFLAGS[@]} -xf77)
			libs+=(${LIBS[@]})
			;;
		f95+ld)
			compiler="$(tc-getFC)"
			filename_in="${T}/test.f90"
			filename_out="${T}/test.exe"
			args+=(${FCFLAGS[@]} ${LDFLAGS[@]} -xf95)
			libs+=(${LIBS[@]})
			;;
		*)
			die "Unknown compiled language ${lang}"
			;;
	esac

	printf "%s\n" "${code}" > "${filename_in}" || die "Failed to create '${test_in}'"

	"${compiler}" ${args[@]} "${filename_in}" -o "${filename_out}" ${libs[@]} &>/dev/null
}

# @FUNCTION: append-atomic-flags
# @DESCRIPTION:
# Attempts to detect if appending -latomic works, and does so.
append-atomic-flags() {
	# Make sure that the flag is actually valid. If it isn't, then maybe the
	# library both doesn't exist and is redundant, or maybe the toolchain is
	# broken, but let the build succeed or fail on its own.
	test-flags-CCLD "-latomic" &>/dev/null || return

	# We unconditionally append this flag. In the case that it's needed, the
	# flag is, well, needed. In the case that it's not needed, it causes no
	# harm, because we ensure that this specific library is definitely
	# certainly linked with as-needed.
	#
	# Really, this should be implemented directly in the compiler, including
	# the use of push/pop for as-needed. It's exactly what the gcc spec file
	# does for e.g. -lgcc_s, but gcc is concerned about doing so due to build
	# system internals and as a result all users have to deal with this mess
	# instead.
	#
	# See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=81358
	append-libs "-Wl,--push-state,--as-needed,-latomic,--pop-state"
}

fi
