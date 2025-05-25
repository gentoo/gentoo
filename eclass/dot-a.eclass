# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: dot-a.eclass
# @MAINTAINER:
# Toolchain Ninjas <toolchain@gentoo.org>
# @AUTHOR:
# Sam James <sam@gentoo.org>
# Eli Schwartz <eschwartz@gentoo.org>
# @SUPPORTED_EAPIS: 8
# @BLURB: Functions to handle stripping LTO bytecode out of static archives.
# @DESCRIPTION:
# This eclass provides functions to strip LTO bytecode out of static archives
# (.a files).
#
# Static libraries when built with LTO will contain LTO bytecode which is
# not portable across compiler versions or compiler vendors. To avoid pessimising
# the library and always filtering LTO, we can build it with -ffat-lto-objects
# instead, which builds some components twice. The installed part will then
# have the LTO contents stripped out, leaving the regular objects in the
# static archive.
#
# Use should be passing calling lto-guarantee-fat before configure-time
# and calling strip-lto-bytecode after installation.
#
# Most packages installing static libraries should be using this eclass,
# though it's not strictly necessary if the package filters LTO.
#
# @EXAMPLE:
# @CODE
#
# inherit dot-a
#
# src_configure() {
#     lto-guarantee-fat
#     econf
# }
#
# src_install() {
#     default
#     strip-lto-bytecode
# }
case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_DOT_A_ECLASS} ]] ; then
_DOT_A_ECLASS=1

inherit flag-o-matic toolchain-funcs

# TODO: QA check

# @FUNCTION: lto-guarantee-fat
# @DESCRIPTION:
# If LTO is enabled, appends -ffat-lto-objects or any other flags needed
# to provide fat LTO objects.
lto-guarantee-fat() {
	tc-is-lto || return

	# We add this for all languages as LTO obviously can't be done
	# if different compilers are used for e.g. C vs C++ anyway.
	append-flags $(test-flags-CC -ffat-lto-objects)
}

# @FUNCTION: strip-lto-bytecode
# @USAGE: [library|directory] [...]
# @DESCRIPTION:
# Strips LTO bytecode from libraries (static archives) passed as arguments.
# Defaults to operating on ${ED} as a whole if no arguments are passed.
#
# As an optimisation, if USE=static-libs exists for a package and is disabled,
# the default-searching behaviour with no arguments is suppressed.
strip-lto-bytecode() {
	tc-is-lto || return

	local files=()

	if [[ ${#} -eq 0 ]]; then
		if ! in_iuse static-libs || use static-libs ; then
			# maybe we are USE=static-libs. Alternatively, maybe the ebuild doesn't
			# offer such a choice. In both cases, the user specified the function,
			# so we expect to be called on *something*, but nothing was explicitly
			# passed. Try scanning ${ED} automatically.
			set -- "${ED}"
		else
			return
		fi
	fi

	mapfile -t -d '' files < <(find -H "${@}" -type f \( -name '*.a' -or -name '*.o' \) -print0)

	toolchain_type=
	tc-is-gcc && toolchain_type=gnu
	tc-is-clang && toolchain_type=llvm

	local file
	for file in "${files[@]}" ; do
		case ${toolchain_type} in
			gnu)
				$(tc-getSTRIP) \
					-R .gnu.lto_* \
					-R .gnu.debuglto_* \
					-N __gnu_lto_v1 \
					"${file}" || die "Stripping bytecode in ${file} failed"
				;;
			llvm)
				llvm-bitcode-strip \
					-r "${file}" \
					-o "${file}" || die "Stripping bytecode in ${file} failed"
				;;
			*)
				;;
		esac
	done
}

fi
