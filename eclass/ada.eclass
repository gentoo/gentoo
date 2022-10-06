# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ada.eclass
# @MAINTAINER:
# Ada team <ada@gentoo.org>
# @AUTHOR:
# Tupone Alfredo <tupone@gentoo.org>
# @SUPPORTED_EAPIS: 6 7
# @BLURB: An eclass for Ada packages
# @DESCRIPTION:
# This eclass set the ``IUSE`` and ``REQUIRED_USE`` to request the
# ``ADA_TARGET`` when the inheriting ebuild can be supported by more than one
# Ada implementation. It also set ADA_USEDEP and ADA_DEPS with a suitable form.
# A common eclass providing helper functions to build and install
# packages supporting Ada implementations.
#
# This eclass sets correct ``IUSE``. Modification of ``REQUIRED_USE`` has to
# be done by the author of the ebuild (but ``ADA_REQUIRED_USE`` is
# provided for convenience, see below). ada exports ``ADA_DEPS``
# and ``ADA_USEDEP`` so you can create correct dependencies for your
# package easily.
#
# Mostly copied from ``python-single-r1.eclass``

case "${EAPI:-0}" in
	0|1|2|3|4|5)
		die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}"
		;;
	6|7)
		# EAPI=5 is required for sane USE_EXPAND dependencies
		;;
	*)
		die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
		;;
esac

EXPORT_FUNCTIONS pkg_setup

# @ECLASS_VARIABLE: ADA_DEPS
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# This is an eclass-generated Ada dependency string for all
# implementations listed in ``ADA_COMPAT``.
#
# The dependency string is conditional on ``ADA_TARGET``.
#
# Example use:
# @CODE
# RDEPEND="${ADA_DEPS}
#   dev-foo/mydep"
# DEPEND="${RDEPEND}"
# @CODE
#

# @ECLASS_VARIABLE: _ADA_ALL_IMPLS
# @INTERNAL
# @DESCRIPTION:
# All supported Ada implementations, most preferred last.
_ADA_ALL_IMPLS=(
	gnat_2020 gnat_2021 gcc_12_2_0
)
readonly _ADA_ALL_IMPLS


# @FUNCTION: _ada_impl_supported
# @USAGE: <impl>
# @INTERNAL
# @DESCRIPTION:
# Check whether the implementation <impl> (``ADA_COMPAT``-form)
# is still supported.
#
# Returns 0 if the implementation is valid and supported. If it is
# unsupported, returns 1 -- and the caller should ignore the entry.
# If it is invalid, dies with an appopriate error messages.
_ada_impl_supported() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${#} -eq 1 ]] || die "${FUNCNAME}: takes exactly 1 argument (impl)."

	local impl=${1}

	# keep in sync with _ADA_ALL_IMPLS!
	# (not using that list because inline patterns shall be faster)
	case "${impl}" in
		gnat_202[01])
			return 0
			;;
		gcc_12_2_0)
			return 0
			;;
		*)
			[[ ${ADA_COMPAT_NO_STRICT} ]] && return 1
			die "Invalid implementation in ADA_COMPAT: ${impl}"
	esac
}

# @FUNCTION: _ada_set_impls
# @INTERNAL
# @DESCRIPTION:
# Check ``ADA_COMPAT`` for well-formedness and validity, then set
# two global variables:
#
# - ``_ADA_SUPPORTED_IMPLS`` containing valid implementations supported
#   by the ebuild (``ADA_COMPAT`` - dead implementations),
#
# - and ``_ADA_UNSUPPORTED_IMPLS`` containing valid implementations that
#   are not supported by the ebuild.
#
# Implementations in both variables are ordered using the pre-defined
# eclass implementation ordering.
#
# This function must be called once in global scope by an eclass
# utilizing ``ADA_COMPAT``.
_ada_set_impls() {
	local i

	if ! declare -p ADA_COMPAT &>/dev/null; then
		die 'ADA_COMPAT not declared.'
	fi
	if [[ $(declare -p ADA_COMPAT) != "declare -a"* ]]; then
		die 'ADA_COMPAT must be an array.'
	fi
	for i in "${ADA_COMPAT[@]}"; do
		# trigger validity checks
		_ada_impl_supported "${i}"
	done

	local supp=() unsupp=()

	for i in "${_ADA_ALL_IMPLS[@]}"; do
		if has "${i}" "${ADA_COMPAT[@]}"; then
			supp+=( "${i}" )
		else
			unsupp+=( "${i}" )
		fi
	done
	if [[ ! ${supp[@]} ]]; then
		die "No supported implementation in ADA_COMPAT."
	fi

	if [[ ${_ADA_SUPPORTED_IMPLS[@]} ]]; then
		# set once already, verify integrity
		if [[ ${_ADA_SUPPORTED_IMPLS[@]} != ${supp[@]} ]]; then
			eerror "Supported impls (ADA_COMPAT) changed between inherits!"
			eerror "Before: ${_ADA_SUPPORTED_IMPLS[*]}"
			eerror "Now   : ${supp[*]}"
			die "_ADA_SUPPORTED_IMPLS integrity check failed"
		fi
		if [[ ${_ADA_UNSUPPORTED_IMPLS[@]} != ${unsupp[@]} ]]; then
			eerror "Unsupported impls changed between inherits!"
			eerror "Before: ${_ADA_UNSUPPORTED_IMPLS[*]}"
			eerror "Now   : ${unsupp[*]}"
			die "_ADA_UNSUPPORTED_IMPLS integrity check failed"
		fi
	else
		_ADA_SUPPORTED_IMPLS=( "${supp[@]}" )
		_ADA_UNSUPPORTED_IMPLS=( "${unsupp[@]}" )
		readonly _ADA_SUPPORTED_IMPLS _ADA_UNSUPPORTED_IMPLS
	fi
}

# @FUNCTION: ada_export
# @USAGE: [<impl>] <variables>...
# @DESCRIPTION:
# Set and export the Ada implementation-relevant variables passed
# as parameters.
#
# The optional first parameter may specify the requested Ada
# implementation (either as ``ADA_TARGETS`` value, e.g. ``ada2_7``,
# or an ``EADA`` one, e.g. ``ada2.7``). If no implementation passed,
# the current one will be obtained from ``${EADA}``.
#
# The variables which can be exported are: ``GCC``, ``EADA``,
# ``GNATMAKE``. They are described more completely in the eclass
# variable documentation.
ada_export() {
	debug-print-function ${FUNCNAME} "${@}"

	local impl var

	case "${1}" in
		gnat_202[01])
			impl=${1}
			shift
			;;
		gcc_12_2_0)
			impl=${1}
			shift
			;;
		*)
			impl=${EADA}
			if [[ -z ${impl} ]]; then
				die "ada_export called without a ada implementation and EADA is unset"
			fi
			;;
	esac
	debug-print "${FUNCNAME}: implementation: ${impl}"

	local gcc_pv
	local slot
	case "${impl}" in
		gnat_2020)
			gcc_pv=9.3.1
			slot=9.3.1
			;;
		gnat_2021)
			gcc_pv=10.3.1
			slot=10
			;;
		gcc_12_2_0)
			gcc_pv=12.2.0
			slot=12
			;;
		*)
			gcc_pv="9.9.9"
			slot=9.9.9
			;;
	esac

	for var; do
		case "${var}" in
			EADA)
				export EADA=${impl}
				debug-print "${FUNCNAME}: EADA = ${EADA}"
				;;
			GCC)
				export GCC=${EPREFIX}/usr/bin/gcc-${gcc_pv}
				debug-print "${FUNCNAME}: GCC = ${GCC}"
				;;
			GCC_PV)
				export GCC_PV=${gcc_pv}
				debug-print "${FUNCNAME}: GCC_PV = ${GCC_PV}"
				;;
			GNAT)
				export GNAT=${EPREFIX}/usr/bin/gnat-${gcc_pv}
				debug-print "${FUNCNAME}: GNAT = ${GNAT}"
				;;
			GNATBIND)
				export GNATBIND=${EPREFIX}/usr/bin/gnatbind-${gcc_pv}
				debug-print "${FUNCNAME}: GNATBIND = ${GNATBIND}"
				;;
			GNATMAKE)
				export GNATMAKE=${EPREFIX}/usr/bin/gnatmake-${gcc_pv}
				debug-print "${FUNCNAME}: GNATMAKE = ${GNATMAKE}"
				;;
			GNATLS)
				export GNATLS=${EPREFIX}/usr/bin/gnatls-${gcc_pv}
				debug-print "${FUNCNAME}: GNATLS = ${GNATLS}"
				;;
			GNATPREP)
				export GNATPREP=${EPREFIX}/usr/bin/gnatprep-${gcc_pv}
				debug-print "${FUNCNAME}: GNATPREP = ${GNATPREP}"
				;;
			GNATCHOP)
				export GNATCHOP=${EPREFIX}/usr/bin/gnatchop-${gcc_pv}
				debug-print "${FUNCNAME}: GNATCHOP = ${GNATCHOP}"
				;;
			ADA_PKG_DEP)
				case "${impl}" in
					gnat_202[01])
						ADA_PKG_DEP="dev-lang/gnat-gpl:${slot}[ada]"
						;;
					*)
						ADA_PKG_DEP="=sys-devel/gcc-${gcc_pv}*[ada]"
						;;
				esac

				# use-dep
				if [[ ${ADA_REQ_USE} ]]; then
					ADA_PKG_DEP+=[${ADA_REQ_USE}]
				fi

				export ADA_PKG_DEP
				debug-print "${FUNCNAME}: ADA_PKG_DEP = ${ADA_PKG_DEP}"
				;;
			*)
				die "ada_export: unknown variable ${var}"
		esac
	done
}

_ada_single_set_globals() {
	_ada_set_impls
	local i ADA_PKG_DEP

	local flags=( "${_ADA_SUPPORTED_IMPLS[@]/#/ada_target_}" )
	local unflags=( "${_ADA_UNSUPPORTED_IMPLS[@]/#/-ada_target_}" )
	local allflags=( "${_ADA_ALL_IMPLS[@]/#/ada_target_}" )

	local optflags=${flags[@]/%/(-)?}

	IUSE="${allflags[*]}"

	if [[ ${#_ADA_UNSUPPORTED_IMPLS[@]} -gt 0 ]]; then
		optflags+=,${unflags[@]/%/(-)}
	fi

	local deps requse usedep
	if [[ ${#_ADA_SUPPORTED_IMPLS[@]} -eq 1 ]]; then
		# There is only one supported implementation; set IUSE and other
		# variables without ADA_SINGLE_TARGET.
		requse=${flags[*]}
		ada_export "${_ADA_SUPPORTED_IMPLS[0]}" ADA_PKG_DEP
		deps="${flags[*]}? ( ${ADA_PKG_DEP} ) "
	else
		# Multiple supported implementations; honor ADA_TARGET.
		requse="^^ ( ${flags[*]} )"

		for i in "${_ADA_SUPPORTED_IMPLS[@]}"; do
			ada_export "${i}" ADA_PKG_DEP
			deps+="ada_target_${i}? ( ${ADA_PKG_DEP} ) "
		done
	fi
	usedep=${optflags// /,}
	if [[ ${ADA_DEPS+1} ]]; then
		if [[ ${ADA_DEPS} != "${deps}" ]]; then
			eerror "ADA_DEPS have changed between inherits (ADA_REQ_USE?)!"
			eerror "Before: ${ADA_DEPS}"
			eerror "Now   : ${deps}"
			die "ADA_DEPS integrity check failed"
		fi

		# these two are formality -- they depend on ADA_COMPAT only
		if [[ ${ADA_REQUIRED_USE} != ${requse} ]]; then
			eerror "ADA_REQUIRED_USE have changed between inherits!"
			eerror "Before: ${ADA_REQUIRED_USE}"
			eerror "Now   : ${requse}"
			die "ADA_REQUIRED_USE integrity check failed"
		fi

		if [[ ${ADA_USEDEP} != "${usedep}" ]]; then
			eerror "ADA_USEDEP have changed between inherits!"
			eerror "Before: ${ADA_USEDEP}"
			eerror "Now   : ${usedep}"
			die "ADA_USEDEP integrity check failed"
		fi
	else
		ADA_DEPS=${deps}
		ADA_REQUIRED_USE=${requse}
		ADA_USEDEP=${usedep}
		readonly ADA_DEPS ADA_REQUIRED_USE ADA_USEDEP
	fi
}
_ada_single_set_globals
unset -f _ada_single_set_globals

# @FUNCTION: ada_wrapper_setup
# @USAGE: [<path> [<impl>]]
# @DESCRIPTION:
# Create proper 'ada' executable wrappers
# in the directory named by ``<path>``. Set up PATH
# appropriately. ``<path>`` defaults to ``${T}/${EADA}``.
#
# The wrappers will be created for implementation named by ``<impl>``,
# or for one named by ``${EADA}`` if no ``<impl>`` passed.
#
# If the named directory contains a ada symlink already, it will
# be assumed to contain proper wrappers already and only environment
# setup will be done. If wrapper update is requested, the directory
# shall be removed first.
ada_wrapper_setup() {
	debug-print-function ${FUNCNAME} "${@}"

	local workdir=${1:-${T}/${EADA}}
	local impl=${2:-${EADA}}

	[[ ${workdir} ]] || die "${FUNCNAME}: no workdir specified."
	[[ ${impl} ]] || die "${FUNCNAME}: no impl nor EADA specified."

	if [[ ! -x ${workdir}/bin/gnatmake ]]; then
		mkdir -p "${workdir}"/bin || die

		local GCC GNATMAKE GNATLS GNATBIND GNATCHOP GNATPREP
		ada_export "${impl}" GCC GNAT GNATMAKE GNATLS GNATCHOP GNATBIND GNATPREP

		# Ada compiler
		cat > "${workdir}/bin/gcc" <<-_EOF_ || die
			#!/bin/sh
			exec "${GCC}" "\${@}"
		_EOF_
		chmod a+x "${workdir}/bin/gcc" || die
		cat > "${workdir}/bin/gnatmake" <<-_EOF_ || die
			#!/bin/sh
			exec "${GNATMAKE}" "\${@}"
		_EOF_
		chmod a+x "${workdir}/bin/gnatmake" || die
		cat > "${workdir}/bin/gnatls" <<-_EOF_ || die
			#!/bin/sh
			exec "${GNATLS}" "\${@}"
		_EOF_
		chmod a+x "${workdir}/bin/gnatls" || die
		cat > "${workdir}/bin/gnatbind" <<-_EOF_ || die
			#!/bin/sh
			exec "${GNATBIND}" "\${@}"
		_EOF_
		chmod a+x "${workdir}/bin/gnatbind" || die
		cat > "${workdir}/bin/gnatchop" <<-_EOF_ || die
			#!/bin/sh
			exec "${GNATCHOP}" "\${@}"
		_EOF_
		chmod a+x "${workdir}/bin/gnatchop" || die
		cat > "${workdir}/bin/gnatprep" <<-_EOF_ || die
			#!/bin/sh
			exec "${GNATPREP}" "\${@}"
		_EOF_
		chmod a+x "${workdir}/bin/gnatprep" || die
		cat > "${workdir}/bin/gnat" <<-_EOF_ || die
			#!/bin/sh
			exec "${GNAT}" "\${@}"
		_EOF_
		chmod a+x "${workdir}/bin/gnat" || die
	fi

	# Now, set the environment.
	# But note that ${workdir} may be shared with something else,
	# and thus already on top of PATH.
	if [[ ${PATH##:*} != ${workdir}/bin ]]; then
		PATH=${workdir}/bin${PATH:+:${PATH}}
	fi
	export PATH
}

# @FUNCTION: ada_setup
# @DESCRIPTION:
# Determine what the selected Ada implementation is and set
# the Ada build environment up for it.
ada_setup() {
	debug-print-function ${FUNCNAME} "${@}"

	unset EADA

	if [[ ${#_ADA_SUPPORTED_IMPLS[@]} -eq 1 ]]; then
		if use "ada_target_${_ADA_SUPPORTED_IMPLS[0]}"; then
			# Only one supported implementation, enable it explicitly
			ada_export "${_ADA_SUPPORTED_IMPLS[0]}" EADA GCC_PV GNAT GNATBIND GNATLS GNATMAKE
			ada_wrapper_setup
		fi
	else
		local impl
		for impl in "${_ADA_SUPPORTED_IMPLS[@]}"; do
			if use "ada_target_${impl}"; then
				if [[ ${EADA} ]]; then
					eerror "Your ADA_TARGET setting lists more than a single Ada"
					eerror "implementation. Please set it to just one value. If you need"
					eerror "to override the value for a single package, please use package.env"
					eerror "or an equivalent solution (man 5 portage)."
					echo
					die "More than one implementation in ADA_TARGET."
				fi

				ada_export "${impl}" EADA GCC_PV GNAT GNATBIND GNATLS GNATMAKE
				ada_wrapper_setup
			fi
		done
	fi

	if [[ ! ${EADA} ]]; then
		eerror "No Ada implementation selected for the build. Please set"
		if [[ ${#_ADA_SUPPORTED_IMPLS[@]} -eq 1 ]]; then
			eerror "the ADA_TARGETS variable in your make.conf to include one"
		else
			eerror "the ADA_SINGLE_TARGET variable in your make.conf to one"
		fi
		eerror "of the following values:"
		eerror
		eerror "${_ADA_SUPPORTED_IMPLS[@]}"
		echo
		die "No supported Ada implementation in ADA_SINGLE_TARGET/ADA_TARGETS."
	fi
}

# @FUNCTION: ada_pkg_setup
# @DESCRIPTION:
# Runs ``ada_setup``.
ada_pkg_setup() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${MERGE_TYPE} != binary ]] && ada_setup
}
