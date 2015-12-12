# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: python.eclass
# @MAINTAINER:
# Gentoo Python Project <python@gentoo.org>
# @BLURB: Eclass for Python packages
# @DESCRIPTION:
# The python eclass contains miscellaneous, useful functions for Python packages.
#
# This eclass is DEPRECATED. Please use python-r1, python-single-r1
# or python-any-r1 instead.

if [[ ${EAPI} == 6 ]]; then
	die "${ECLASS}.eclass is banned in EAPI ${EAPI}"
fi

if [[ ${_PYTHON_UTILS_R1} ]]; then
	die 'python.eclass can not be used with python-r1 suite eclasses.'
fi

# Must call inherit before EXPORT_FUNCTIONS to avoid QA warning.
if [[ -z "${_PYTHON_ECLASS_INHERITED}" ]]; then
	inherit multilib
fi

# Export pkg_setup every time to avoid issues with eclass inheritance order.
if ! has "${EAPI:-0}" 0 1 2 3 || { has "${EAPI:-0}" 2 3 && [[ -n "${PYTHON_USE_WITH}" || -n "${PYTHON_USE_WITH_OR}" ]]; }; then
	EXPORT_FUNCTIONS pkg_setup
fi

# Avoid processing this eclass more than once.
if [[ -z "${_PYTHON_ECLASS_INHERITED}" ]]; then
_PYTHON_ECLASS_INHERITED="1"

if ! has "${EAPI:-0}" 0 1 2 3 4 5; then
	die "API of python.eclass in EAPI=\"${EAPI}\" not established"
fi

# Please do not add any new versions of Python here! Instead, please
# focus on converting packages to use the new eclasses.

_CPYTHON2_GLOBALLY_SUPPORTED_ABIS=(2.4 2.5 2.6 2.7)
_CPYTHON3_GLOBALLY_SUPPORTED_ABIS=(3.1 3.2 3.3)
_JYTHON_GLOBALLY_SUPPORTED_ABIS=(2.5-jython 2.7-jython)
_PYPY_GLOBALLY_SUPPORTED_ABIS=(2.7-pypy-1.7 2.7-pypy-1.8 2.7-pypy-1.9 2.7-pypy-2.0)
_PYTHON_GLOBALLY_SUPPORTED_ABIS=(${_CPYTHON2_GLOBALLY_SUPPORTED_ABIS[@]} ${_CPYTHON3_GLOBALLY_SUPPORTED_ABIS[@]} ${_JYTHON_GLOBALLY_SUPPORTED_ABIS[@]} ${_PYPY_GLOBALLY_SUPPORTED_ABIS[@]})

# ================================================================================================
# ===================================== HANDLING OF METADATA =====================================
# ================================================================================================

_PYTHON_ABI_PATTERN_REGEX="([[:alnum:]]|\.|-|\*|\[|\])+"

_python_check_python_abi_matching() {
	local pattern patterns patterns_list="0" PYTHON_ABI

	while (($#)); do
		case "$1" in
			--patterns-list)
				patterns_list="1"
				;;
			--)
				shift
				break
				;;
			-*)
				die "${FUNCNAME}(): Unrecognized option '$1'"
				;;
			*)
				break
				;;
		esac
		shift
	done

	if [[ "$#" -ne 2 ]]; then
		die "${FUNCNAME}() requires 2 arguments"
	fi

	PYTHON_ABI="$1"

	if [[ "${patterns_list}" == "0" ]]; then
		pattern="$2"

		if [[ "${pattern}" == *"-cpython" ]]; then
			[[ "${PYTHON_ABI}" =~ ^[[:digit:]]+\.[[:digit:]]+$ && "${PYTHON_ABI}" == ${pattern%-cpython} ]]
		elif [[ "${pattern}" == *"-jython" ]]; then
			[[ "${PYTHON_ABI}" == ${pattern} ]]
		elif [[ "${pattern}" == *"-pypy-"* ]]; then
			[[ "${PYTHON_ABI}" == ${pattern} ]]
		else
			if [[ "${PYTHON_ABI}" =~ ^[[:digit:]]+\.[[:digit:]]+$ ]]; then
				[[ "${PYTHON_ABI}" == ${pattern} ]]
			elif [[ "${PYTHON_ABI}" =~ ^[[:digit:]]+\.[[:digit:]]+-jython$ ]]; then
				[[ "${PYTHON_ABI%-jython}" == ${pattern} ]]
			elif [[ "${PYTHON_ABI}" =~ ^[[:digit:]]+\.[[:digit:]]+-pypy-[[:digit:]]+\.[[:digit:]]+$ ]]; then
				[[ "${PYTHON_ABI%-pypy-*}" == ${pattern} ]]
			else
				die "${FUNCNAME}(): Unrecognized Python ABI '${PYTHON_ABI}'"
			fi
		fi
	else
		patterns="${2// /$'\n'}"

		while read pattern; do
			if _python_check_python_abi_matching "${PYTHON_ABI}" "${pattern}"; then
				return 0
			fi
		done <<< "${patterns}"

		return 1
	fi
}

_python_implementation() {
	if [[ "${CATEGORY}/${PN}" == "dev-lang/python" ]]; then
		return 0
	elif [[ "${CATEGORY}/${PN}" == "dev-java/jython" ]]; then
		return 0
	elif [[ "${CATEGORY}/${PN}" == "virtual/pypy" ]]; then
		return 0
	else
		return 1
	fi
}

_python_package_supporting_installation_for_multiple_python_abis() {
	[[ -n "${SUPPORT_PYTHON_ABIS}" ]]
}

# @ECLASS-VARIABLE: PYTHON_DEPEND
# @DESCRIPTION:
# Specification of dependency on dev-lang/python.
# Syntax:
#   PYTHON_DEPEND:             [[!]USE_flag? ]<version_components_group>[ version_components_group]
#   version_components_group:  <major_version[:[minimal_version][:maximal_version]]>
#   major_version:             <2|3|*>
#   minimal_version:           <minimal_major_version.minimal_minor_version>
#   maximal_version:           <maximal_major_version.maximal_minor_version>

_python_parse_PYTHON_DEPEND() {
	local major_version maximal_version minimal_version python_all="0" python_maximal_version python_minimal_version python_versions=() python2="0" python2_maximal_version python2_minimal_version python3="0" python3_maximal_version python3_minimal_version USE_flag= version_components_group version_components_group_regex version_components_groups

	version_components_group_regex="(2|3|\*)(:([[:digit:]]+\.[[:digit:]]+)?(:([[:digit:]]+\.[[:digit:]]+)?)?)?"
	version_components_groups="${PYTHON_DEPEND}"

	if [[ "${version_components_groups}" =~ ^((\!)?[[:alnum:]_-]+\?\ )?${version_components_group_regex}(\ ${version_components_group_regex})?$ ]]; then
		if [[ "${version_components_groups}" =~ ^(\!)?[[:alnum:]_-]+\? ]]; then
			USE_flag="${version_components_groups%\? *}"
			version_components_groups="${version_components_groups#* }"
		fi
		if [[ "${version_components_groups}" =~ ("*".*" "|" *"|^2.*\ (2|\*)|^3.*\ (3|\*)) ]]; then
			die "Invalid syntax of PYTHON_DEPEND: Incorrectly specified groups of versions"
		fi

		version_components_groups="${version_components_groups// /$'\n'}"
		while read version_components_group; do
			major_version="${version_components_group:0:1}"
			minimal_version="${version_components_group:2}"
			minimal_version="${minimal_version%:*}"
			maximal_version="${version_components_group:$((3 + ${#minimal_version}))}"

			if [[ "${major_version}" =~ ^(2|3)$ ]]; then
				if [[ -n "${minimal_version}" && "${major_version}" != "${minimal_version:0:1}" ]]; then
					die "Invalid syntax of PYTHON_DEPEND: Minimal version '${minimal_version}' not in specified group of versions"
				fi
				if [[ -n "${maximal_version}" && "${major_version}" != "${maximal_version:0:1}" ]]; then
					die "Invalid syntax of PYTHON_DEPEND: Maximal version '${maximal_version}' not in specified group of versions"
				fi
			fi

			if [[ "${major_version}" == "2" ]]; then
				python2="1"
				python_versions=("${_CPYTHON2_GLOBALLY_SUPPORTED_ABIS[@]}")
				python2_minimal_version="${minimal_version}"
				python2_maximal_version="${maximal_version}"
			elif [[ "${major_version}" == "3" ]]; then
				python3="1"
				python_versions=("${_CPYTHON3_GLOBALLY_SUPPORTED_ABIS[@]}")
				python3_minimal_version="${minimal_version}"
				python3_maximal_version="${maximal_version}"
			else
				python_all="1"
				python_versions=("${_CPYTHON2_GLOBALLY_SUPPORTED_ABIS[@]}" "${_CPYTHON3_GLOBALLY_SUPPORTED_ABIS[@]}")
				python_minimal_version="${minimal_version}"
				python_maximal_version="${maximal_version}"
			fi

			if [[ -n "${minimal_version}" ]] && ! has "${minimal_version}" "${python_versions[@]}"; then
				die "Invalid syntax of PYTHON_DEPEND: Unrecognized minimal version '${minimal_version}'"
			fi
			if [[ -n "${maximal_version}" ]] && ! has "${maximal_version}" "${python_versions[@]}"; then
				die "Invalid syntax of PYTHON_DEPEND: Unrecognized maximal version '${maximal_version}'"
			fi

			if [[ -n "${minimal_version}" && -n "${maximal_version}" && "${minimal_version}" > "${maximal_version}" ]]; then
				die "Invalid syntax of PYTHON_DEPEND: Minimal version '${minimal_version}' greater than maximal version '${maximal_version}'"
			fi
		done <<< "${version_components_groups}"

		_PYTHON_ATOMS=()

		_append_accepted_versions_range() {
			local accepted_version="0" i
			for ((i = "${#python_versions[@]}"; i >= 0; i--)); do
				if [[ "${python_versions[${i}]}" == "${python_maximal_version}" ]]; then
					accepted_version="1"
				fi
				if [[ "${accepted_version}" == "1" ]]; then
					_PYTHON_ATOMS+=("=dev-lang/python-${python_versions[${i}]}*")
				fi
				if [[ "${python_versions[${i}]}" == "${python_minimal_version}" ]]; then
					accepted_version="0"
				fi
			done
		}

		if [[ "${python_all}" == "1" ]]; then
			if [[ -z "${python_minimal_version}" && -z "${python_maximal_version}" ]]; then
				_PYTHON_ATOMS+=("dev-lang/python")
			else
				python_versions=("${_CPYTHON2_GLOBALLY_SUPPORTED_ABIS[@]}" "${_CPYTHON3_GLOBALLY_SUPPORTED_ABIS[@]}")
				python_minimal_version="${python_minimal_version:-${python_versions[0]}}"
				python_maximal_version="${python_maximal_version:-${python_versions[${#python_versions[@]}-1]}}"
				_append_accepted_versions_range
			fi
		else
			if [[ "${python3}" == "1" ]]; then
				if [[ -z "${python3_minimal_version}" && -z "${python3_maximal_version}" ]]; then
					_PYTHON_ATOMS+=("=dev-lang/python-3*")
				else
					python_versions=("${_CPYTHON3_GLOBALLY_SUPPORTED_ABIS[@]}")
					python_minimal_version="${python3_minimal_version:-${python_versions[0]}}"
					python_maximal_version="${python3_maximal_version:-${python_versions[${#python_versions[@]}-1]}}"
					_append_accepted_versions_range
				fi
			fi
			if [[ "${python2}" == "1" ]]; then
				if [[ -z "${python2_minimal_version}" && -z "${python2_maximal_version}" ]]; then
					_PYTHON_ATOMS+=("=dev-lang/python-2*")
				else
					python_versions=("${_CPYTHON2_GLOBALLY_SUPPORTED_ABIS[@]}")
					python_minimal_version="${python2_minimal_version:-${python_versions[0]}}"
					python_maximal_version="${python2_maximal_version:-${python_versions[${#python_versions[@]}-1]}}"
					_append_accepted_versions_range
				fi
			fi
		fi

		unset -f _append_accepted_versions_range

		if [[ "${#_PYTHON_ATOMS[@]}" -gt 1 ]]; then
			DEPEND+="${DEPEND:+ }${USE_flag}${USE_flag:+? ( }|| ( ${_PYTHON_ATOMS[@]} )${USE_flag:+ )}"
			RDEPEND+="${RDEPEND:+ }${USE_flag}${USE_flag:+? ( }|| ( ${_PYTHON_ATOMS[@]} )${USE_flag:+ )}"
		else
			DEPEND+="${DEPEND:+ }${USE_flag}${USE_flag:+? ( }${_PYTHON_ATOMS[@]}${USE_flag:+ )}"
			RDEPEND+="${RDEPEND:+ }${USE_flag}${USE_flag:+? ( }${_PYTHON_ATOMS[@]}${USE_flag:+ )}"
		fi
	else
		die "Invalid syntax of PYTHON_DEPEND"
	fi
}

if _python_implementation; then
	DEPEND=">=app-eselect/eselect-python-20091230"
	RDEPEND="${DEPEND}"
	PDEPEND="app-admin/python-updater"
fi

if [[ -n "${PYTHON_DEPEND}" ]]; then
	_python_parse_PYTHON_DEPEND
else
	_PYTHON_ATOMS=("dev-lang/python")
fi
unset -f _python_parse_PYTHON_DEPEND

if [[ -n "${NEED_PYTHON}" ]]; then
	eerror "Use PYTHON_DEPEND variable instead of NEED_PYTHON variable."
	die "NEED_PYTHON variable is banned"
fi

# @ECLASS-VARIABLE: PYTHON_USE_WITH
# @DESCRIPTION:
# Set this to a space separated list of USE flags the Python slot in use must be built with.

# @ECLASS-VARIABLE: PYTHON_USE_WITH_OR
# @DESCRIPTION:
# Set this to a space separated list of USE flags of which one must be turned on for the slot in use.

# @ECLASS-VARIABLE: PYTHON_USE_WITH_OPT
# @DESCRIPTION:
# Set this to a name of a USE flag if you need to make either PYTHON_USE_WITH or
# PYTHON_USE_WITH_OR atoms conditional under a USE flag.

if ! has "${EAPI:-0}" 0 1 && [[ -n ${PYTHON_USE_WITH} || -n ${PYTHON_USE_WITH_OR} ]]; then
	_PYTHON_USE_WITH_ATOMS_ARRAY=()
	if [[ -n "${PYTHON_USE_WITH}" ]]; then
		for _PYTHON_ATOM in "${_PYTHON_ATOMS[@]}"; do
			_PYTHON_USE_WITH_ATOMS_ARRAY+=("${_PYTHON_ATOM}[${PYTHON_USE_WITH// /,}]")
		done
	elif [[ -n "${PYTHON_USE_WITH_OR}" ]]; then
		for _USE_flag in ${PYTHON_USE_WITH_OR}; do
			for _PYTHON_ATOM in "${_PYTHON_ATOMS[@]}"; do
				_PYTHON_USE_WITH_ATOMS_ARRAY+=("${_PYTHON_ATOM}[${_USE_flag}]")
			done
		done
		unset _USE_flag
	fi
	if [[ "${#_PYTHON_USE_WITH_ATOMS_ARRAY[@]}" -gt 1 ]]; then
		_PYTHON_USE_WITH_ATOMS="|| ( ${_PYTHON_USE_WITH_ATOMS_ARRAY[@]} )"
	else
		_PYTHON_USE_WITH_ATOMS="${_PYTHON_USE_WITH_ATOMS_ARRAY[@]}"
	fi
	if [[ -n "${PYTHON_USE_WITH_OPT}" ]]; then
		_PYTHON_USE_WITH_ATOMS="${PYTHON_USE_WITH_OPT}? ( ${_PYTHON_USE_WITH_ATOMS} )"
	fi
	DEPEND+="${DEPEND:+ }${_PYTHON_USE_WITH_ATOMS}"
	RDEPEND+="${RDEPEND:+ }${_PYTHON_USE_WITH_ATOMS}"
	unset _PYTHON_ATOM _PYTHON_USE_WITH_ATOMS _PYTHON_USE_WITH_ATOMS_ARRAY
fi

unset _PYTHON_ATOMS

# ================================================================================================
# =================================== MISCELLANEOUS FUNCTIONS ====================================
# ================================================================================================

_python_abi-specific_local_scope() {
	[[ " ${FUNCNAME[@]:2} " =~ " "(_python_final_sanity_checks|python_execute_function|python_mod_optimize|python_mod_cleanup)" " ]]
}

_python_initialize_prefix_variables() {
	if has "${EAPI:-0}" 0 1 2; then
		if [[ -n "${ROOT}" && -z "${EROOT}" ]]; then
			EROOT="${ROOT%/}${EPREFIX}/"
		fi
		if [[ -n "${D}" && -z "${ED}" ]]; then
			ED="${D%/}${EPREFIX}/"
		fi
	fi
}

unset PYTHON_SANITY_CHECKS_EXECUTED PYTHON_SKIP_SANITY_CHECKS

_python_initial_sanity_checks() {
	:
}

_python_final_sanity_checks() {
	if ! _python_implementation && [[ "$(declare -p PYTHON_SANITY_CHECKS_EXECUTED 2> /dev/null)" != "declare -- PYTHON_SANITY_CHECKS_EXECUTED="* || " ${FUNCNAME[@]:1} " =~ " "(python_set_active_version|python_pkg_setup)" " && -z "${PYTHON_SKIP_SANITY_CHECKS}" ]]; then
		local PYTHON_ABI="${PYTHON_ABI}"
		for PYTHON_ABI in ${PYTHON_ABIS-${PYTHON_ABI}}; do
			# Ensure that appropriate version of Python is installed.
			if ! has_version "$(python_get_implementational_package)"; then
				die "$(python_get_implementational_package) is not installed"
			fi

			# Ensure that EPYTHON variable is respected.
			if [[ "$(EPYTHON="$(PYTHON)" python -c "${_PYTHON_ABI_EXTRACTION_COMMAND}")" != "${PYTHON_ABI}" ]]; then
				eerror "Path to 'python':                 '$(type -p python)'"
				eerror "ABI:                              '${ABI}'"
				eerror "DEFAULT_ABI:                      '${DEFAULT_ABI}'"
				eerror "EPYTHON:                          '$(PYTHON)'"
				eerror "PYTHON_ABI:                       '${PYTHON_ABI}'"
				eerror "Locally active version of Python: '$(EPYTHON="$(PYTHON)" python -c "${_PYTHON_ABI_EXTRACTION_COMMAND}")'"
				die "'python' does not respect EPYTHON variable"
			fi
		done
	fi
	PYTHON_SANITY_CHECKS_EXECUTED="1"
}

# @ECLASS-VARIABLE: PYTHON_COLORS
# @DESCRIPTION:
# User-configurable colored output.
PYTHON_COLORS="${PYTHON_COLORS:-0}"

_python_set_color_variables() {
	if [[ "${PYTHON_COLORS}" != "0" && "${NOCOLOR:-false}" =~ ^(false|no)$ ]]; then
		_BOLD=$'\e[1m'
		_RED=$'\e[1;31m'
		_GREEN=$'\e[1;32m'
		_BLUE=$'\e[1;34m'
		_CYAN=$'\e[1;36m'
		_NORMAL=$'\e[0m'
	else
		_BOLD=
		_RED=
		_GREEN=
		_BLUE=
		_CYAN=
		_NORMAL=
	fi
}

_python_check_python_pkg_setup_execution() {
	[[ " ${FUNCNAME[@]:1} " =~ " "(python_set_active_version|python_pkg_setup)" " ]] && return

	if ! has "${EAPI:-0}" 0 1 2 3 && [[ -z "${PYTHON_PKG_SETUP_EXECUTED}" ]]; then
		die "python_pkg_setup() not called"
	fi
}

# @FUNCTION: python_pkg_setup
# @DESCRIPTION:
# Perform sanity checks and initialize environment.
#
# This function is exported in EAPI 2 and 3 when PYTHON_USE_WITH or PYTHON_USE_WITH_OR variable
# is set and always in EAPI >=4. Calling of this function is mandatory in EAPI >=4.
python_pkg_setup() {
	if [[ "${EBUILD_PHASE}" != "setup" ]]; then
		die "${FUNCNAME}() can be used only in pkg_setup() phase"
	fi

	if [[ "$#" -ne 0 ]]; then
		die "${FUNCNAME}() does not accept arguments"
	fi

	export JYTHON_SYSTEM_CACHEDIR="1"
	addwrite "${EPREFIX}/var/cache/jython"

	if _python_package_supporting_installation_for_multiple_python_abis; then
		_python_calculate_PYTHON_ABIS
		export EPYTHON="$(PYTHON -f)"
	else
		PYTHON_ABI="${PYTHON_ABI:-$(PYTHON --ABI)}"
	fi

	if ! has "${EAPI:-0}" 0 1 && [[ -n "${PYTHON_USE_WITH}" || -n "${PYTHON_USE_WITH_OR}" ]]; then
		if [[ "${PYTHON_USE_WITH_OPT}" ]]; then
			if [[ "${PYTHON_USE_WITH_OPT}" == !* ]]; then
				use ${PYTHON_USE_WITH_OPT#!} && return
			else
				use !${PYTHON_USE_WITH_OPT} && return
			fi
		fi

		python_pkg_setup_check_USE_flags() {
			local python_atom USE_flag
			python_atom="$(python_get_implementational_package)"

			for USE_flag in ${PYTHON_USE_WITH}; do
				if ! has_version "${python_atom}[${USE_flag}]"; then
					eerror "Please rebuild ${python_atom} with the following USE flags enabled: ${PYTHON_USE_WITH}"
					die "Please rebuild ${python_atom} with the following USE flags enabled: ${PYTHON_USE_WITH}"
				fi
			done

			for USE_flag in ${PYTHON_USE_WITH_OR}; do
				if has_version "${python_atom}[${USE_flag}]"; then
					return
				fi
			done

			if [[ ${PYTHON_USE_WITH_OR} ]]; then
				eerror "Please rebuild ${python_atom} with at least one of the following USE flags enabled: ${PYTHON_USE_WITH_OR}"
				die "Please rebuild ${python_atom} with at least one of the following USE flags enabled: ${PYTHON_USE_WITH_OR}"
			fi
		}

		if _python_package_supporting_installation_for_multiple_python_abis; then
			PYTHON_SKIP_SANITY_CHECKS="1" python_execute_function -q python_pkg_setup_check_USE_flags
		else
			python_pkg_setup_check_USE_flags
		fi

		unset -f python_pkg_setup_check_USE_flags
	fi

	PYTHON_PKG_SETUP_EXECUTED="1"
}

_PYTHON_SHEBANG_BASE_PART_REGEX='^#![[:space:]]*([^[:space:]]*/usr/bin/env[[:space:]]+)?([^[:space:]]*/)?(jython|pypy-c|python)'

# @FUNCTION: python_convert_shebangs
# @USAGE: [-q|--quiet] [-r|--recursive] [-x|--only-executables] [--] <Python_ABI|Python_version> <file|directory> [files|directories]
# @DESCRIPTION:
# Convert shebangs in specified files. Directories can be specified only with --recursive option.
python_convert_shebangs() {
	_python_check_python_pkg_setup_execution

	local argument file files=() only_executables="0" python_interpreter quiet="0" recursive="0" shebangs_converted="0"

	while (($#)); do
		case "$1" in
			-r|--recursive)
				recursive="1"
				;;
			-q|--quiet)
				quiet="1"
				;;
			-x|--only-executables)
				only_executables="1"
				;;
			--)
				shift
				break
				;;
			-*)
				die "${FUNCNAME}(): Unrecognized option '$1'"
				;;
			*)
				break
				;;
		esac
		shift
	done

	if [[ "$#" -eq 0 ]]; then
		die "${FUNCNAME}(): Missing Python version and files or directories"
	elif [[ "$#" -eq 1 ]]; then
		die "${FUNCNAME}(): Missing files or directories"
	fi

	if [[ -n "$(_python_get_implementation --ignore-invalid "$1")" ]]; then
		python_interpreter="$(PYTHON "$1")"
	else
		python_interpreter="python$1"
	fi
	shift

	for argument in "$@"; do
		if [[ ! -e "${argument}" ]]; then
			die "${FUNCNAME}(): '${argument}' does not exist"
		elif [[ -f "${argument}" ]]; then
			files+=("${argument}")
		elif [[ -d "${argument}" ]]; then
			if [[ "${recursive}" == "1" ]]; then
				while read -d $'\0' -r file; do
					files+=("${file}")
				done < <(find "${argument}" $([[ "${only_executables}" == "1" ]] && echo -perm /111) -type f -print0)
			else
				die "${FUNCNAME}(): '${argument}' is not a regular file"
			fi
		else
			die "${FUNCNAME}(): '${argument}' is not a regular file or a directory"
		fi
	done

	for file in "${files[@]}"; do
		file="${file#./}"
		[[ "${only_executables}" == "1" && ! -x "${file}" ]] && continue

		if [[ "$(head -n1 "${file}")" =~ ${_PYTHON_SHEBANG_BASE_PART_REGEX} ]]; then
			[[ "$(sed -ne "2p" "${file}")" =~ ^"# Gentoo '".*"' wrapper script generated by python_generate_wrapper_scripts()"$ ]] && continue

			shebangs_converted="1"

			if [[ "${quiet}" == "0" ]]; then
				einfo "Converting shebang in '${file}'"
			fi

			sed -e "1s:^#![[:space:]]*\([^[:space:]]*/usr/bin/env[[:space:]]\)\?[[:space:]]*\([^[:space:]]*/\)\?\(jython\|pypy-c\|python\)\([[:digit:]]\+\(\.[[:digit:]]\+\)\?\)\?\(\$\|[[:space:]].*\):#!\1\2${python_interpreter}\6:" -i "${file}" || die "Conversion of shebang in '${file}' failed"
		fi
	done

	if [[ "${shebangs_converted}" == "0" ]]; then
		ewarn "${FUNCNAME}(): Python scripts not found"
	fi
}

# @FUNCTION: python_clean_py-compile_files
# @USAGE: [-q|--quiet]
# @DESCRIPTION:
# Clean py-compile files to disable byte-compilation.
python_clean_py-compile_files() {
	_python_check_python_pkg_setup_execution

	local file files=() quiet="0"

	while (($#)); do
		case "$1" in
			-q|--quiet)
				quiet="1"
				;;
			-*)
				die "${FUNCNAME}(): Unrecognized option '$1'"
				;;
			*)
				die "${FUNCNAME}(): Invalid usage"
				;;
		esac
		shift
	done

	while read -d $'\0' -r file; do
		files+=("${file#./}")
	done < <(find -name py-compile -type f -print0)

	for file in "${files[@]}"; do
		if [[ "${quiet}" == "0" ]]; then
			einfo "Cleaning '${file}' file"
		fi
		echo "#!/bin/sh" > "${file}"
	done
}

# @FUNCTION: python_clean_installation_image
# @USAGE: [-q|--quiet]
# @DESCRIPTION:
# Delete needless files in installation image.
#
# This function can be used only in src_install() phase.
python_clean_installation_image() {
	if [[ "${EBUILD_PHASE}" != "install" ]]; then
		die "${FUNCNAME}() can be used only in src_install() phase"
	fi

	_python_check_python_pkg_setup_execution
	_python_initialize_prefix_variables

	local file files=() quiet="0"

	while (($#)); do
		case "$1" in
			-q|--quiet)
				quiet="1"
				;;
			-*)
				die "${FUNCNAME}(): Unrecognized option '$1'"
				;;
			*)
				die "${FUNCNAME}(): Invalid usage"
				;;
		esac
		shift
	done

	while read -d $'\0' -r file; do
		files+=("${file}")
	done < <(find "${ED}" "(" -name "*.py[co]" -o -name "*\$py.class" ")" -type f -print0)

	if [[ "${#files[@]}" -gt 0 ]]; then
		if [[ "${quiet}" == "0" ]]; then
			ewarn "Deleting byte-compiled Python modules needlessly generated by build system:"
		fi
		for file in "${files[@]}"; do
			if [[ "${quiet}" == "0" ]]; then
				ewarn " ${file}"
			fi
			rm -f "${file}"

			# Delete empty __pycache__ directories.
			if [[ "${file%/*}" == *"/__pycache__" ]]; then
				rmdir "${file%/*}" 2> /dev/null
			fi
		done
	fi

	python_clean_sitedirs() {
		if [[ -d "${ED}$(python_get_sitedir)" ]]; then
			find "${ED}$(python_get_sitedir)" "(" -name "*.c" -o -name "*.h" -o -name "*.la" ")" -type f -print0 | xargs -0 rm -f
		fi
	}
	if _python_package_supporting_installation_for_multiple_python_abis; then
		python_execute_function -q python_clean_sitedirs
	else
		python_clean_sitedirs
	fi

	unset -f python_clean_sitedirs
}

# ================================================================================================
# =========== FUNCTIONS FOR PACKAGES SUPPORTING INSTALLATION FOR MULTIPLE PYTHON ABIS ============
# ================================================================================================

# @ECLASS-VARIABLE: SUPPORT_PYTHON_ABIS
# @DESCRIPTION:
# Set this in EAPI <= 4 to indicate that current package supports installation for
# multiple Python ABIs.

# @ECLASS-VARIABLE: PYTHON_TESTS_RESTRICTED_ABIS
# @DESCRIPTION:
# Space-separated list of Python ABI patterns. Testing in Python ABIs matching any Python ABI
# patterns specified in this list is skipped.

# @ECLASS-VARIABLE: PYTHON_EXPORT_PHASE_FUNCTIONS
# @DESCRIPTION:
# Set this to export phase functions for the following ebuild phases:
# src_prepare(), src_configure(), src_compile(), src_test(), src_install().
if ! has "${EAPI:-0}" 0 1; then
	python_src_prepare() {
		if [[ "${EBUILD_PHASE}" != "prepare" ]]; then
			die "${FUNCNAME}() can be used only in src_prepare() phase"
		fi

		if ! _python_package_supporting_installation_for_multiple_python_abis; then
			die "${FUNCNAME}() cannot be used in ebuilds of packages not supporting installation for multiple Python ABIs"
		fi

		_python_check_python_pkg_setup_execution

		if [[ "$#" -ne 0 ]]; then
			die "${FUNCNAME}() does not accept arguments"
		fi

		python_copy_sources
	}

	for python_default_function in src_configure src_compile src_test; do
		eval "python_${python_default_function}() {
			if [[ \"\${EBUILD_PHASE}\" != \"${python_default_function#src_}\" ]]; then
				die \"\${FUNCNAME}() can be used only in ${python_default_function}() phase\"
			fi

			if ! _python_package_supporting_installation_for_multiple_python_abis; then
				die \"\${FUNCNAME}() cannot be used in ebuilds of packages not supporting installation for multiple Python ABIs\"
			fi

			_python_check_python_pkg_setup_execution

			python_execute_function -d -s -- \"\$@\"
		}"
	done
	unset python_default_function

	python_src_install() {
		if [[ "${EBUILD_PHASE}" != "install" ]]; then
			die "${FUNCNAME}() can be used only in src_install() phase"
		fi

		if ! _python_package_supporting_installation_for_multiple_python_abis; then
			die "${FUNCNAME}() cannot be used in ebuilds of packages not supporting installation for multiple Python ABIs"
		fi

		_python_check_python_pkg_setup_execution

		if has "${EAPI:-0}" 0 1 2 3; then
			python_execute_function -d -s -- "$@"
		else
			python_installation() {
				emake DESTDIR="${T}/images/${PYTHON_ABI}" install "$@"
			}
			python_execute_function -s python_installation "$@"
			unset python_installation

			python_merge_intermediate_installation_images "${T}/images"
		fi
	}

	if [[ -n "${PYTHON_EXPORT_PHASE_FUNCTIONS}" ]]; then
		EXPORT_FUNCTIONS src_prepare src_configure src_compile src_test src_install
	fi
fi

unset PYTHON_ABIS

_python_calculate_PYTHON_ABIS() {
	if ! _python_package_supporting_installation_for_multiple_python_abis; then
		die "${FUNCNAME}() cannot be used in ebuilds of packages not supporting installation for multiple Python ABIs"
	fi

	_python_initial_sanity_checks

	if [[ "$(declare -p PYTHON_ABIS 2> /dev/null)" != "declare -x PYTHON_ABIS="* ]]; then
		local PYTHON_ABI

		if [[ "$(declare -p USE_PYTHON 2> /dev/null)" == "declare -x USE_PYTHON="* ]]; then
			local cpython_enabled="0"

			if [[ -z "${USE_PYTHON}" ]]; then
				die "USE_PYTHON variable is empty"
			fi

			for PYTHON_ABI in ${USE_PYTHON}; do
				if ! has "${PYTHON_ABI}" "${_PYTHON_GLOBALLY_SUPPORTED_ABIS[@]}"; then
					die "USE_PYTHON variable contains invalid value '${PYTHON_ABI}'"
				fi

				if has "${PYTHON_ABI}" "${_CPYTHON2_GLOBALLY_SUPPORTED_ABIS[@]}" "${_CPYTHON3_GLOBALLY_SUPPORTED_ABIS[@]}"; then
					cpython_enabled="1"
				fi

				if ! _python_check_python_abi_matching --patterns-list "${PYTHON_ABI}" "${RESTRICT_PYTHON_ABIS}"; then
					export PYTHON_ABIS+="${PYTHON_ABIS:+ }${PYTHON_ABI}"
				fi
			done

			if [[ -z "${PYTHON_ABIS//[${IFS}]/}" ]]; then
				die "USE_PYTHON variable does not enable any Python ABI supported by ${CATEGORY}/${PF}"
			fi

			if [[ "${cpython_enabled}" == "0" ]]; then
				die "USE_PYTHON variable does not enable any CPython ABI"
			fi
		else
			local python_version python2_version python3_version support_python_major_version

			if ! has_version "dev-lang/python"; then
				die "${FUNCNAME}(): 'dev-lang/python' is not installed"
			fi

			python_version="$("${EPREFIX}/usr/bin/python" -c 'from sys import version_info; print(".".join(str(x) for x in version_info[:2]))')"

			if has_version "=dev-lang/python-2*"; then
				if [[ "$(readlink "${EPREFIX}/usr/bin/python2")" != "python2."* ]]; then
					die "'${EPREFIX}/usr/bin/python2' is not a valid symlink"
				fi

				python2_version="$("${EPREFIX}/usr/bin/python2" -c 'from sys import version_info; print(".".join(str(x) for x in version_info[:2]))')"

				support_python_major_version="0"
				for PYTHON_ABI in "${_CPYTHON2_GLOBALLY_SUPPORTED_ABIS[@]}"; do
					if ! _python_check_python_abi_matching --patterns-list "${PYTHON_ABI}" "${RESTRICT_PYTHON_ABIS}"; then
						support_python_major_version="1"
						break
					fi
				done
				if [[ "${support_python_major_version}" == "1" ]]; then
					if _python_check_python_abi_matching --patterns-list "${python2_version}" "${RESTRICT_PYTHON_ABIS}"; then
						die "Active version of CPython 2 is not supported by ${CATEGORY}/${PF}"
					fi
				else
					python2_version=""
				fi
			fi

			if has_version "=dev-lang/python-3*"; then
				if [[ "$(readlink "${EPREFIX}/usr/bin/python3")" != "python3."* ]]; then
					die "'${EPREFIX}/usr/bin/python3' is not a valid symlink"
				fi

				python3_version="$("${EPREFIX}/usr/bin/python3" -c 'from sys import version_info; print(".".join(str(x) for x in version_info[:2]))')"

				support_python_major_version="0"
				for PYTHON_ABI in "${_CPYTHON3_GLOBALLY_SUPPORTED_ABIS[@]}"; do
					if ! _python_check_python_abi_matching --patterns-list "${PYTHON_ABI}" "${RESTRICT_PYTHON_ABIS}"; then
						support_python_major_version="1"
						break
					fi
				done
				if [[ "${support_python_major_version}" == "1" ]]; then
					if _python_check_python_abi_matching --patterns-list "${python3_version}" "${RESTRICT_PYTHON_ABIS}"; then
						die "Active version of CPython 3 is not supported by ${CATEGORY}/${PF}"
					fi
				else
					python3_version=""
				fi
			fi

			if [[ -z "${python2_version}" && -z "${python3_version}" ]]; then
				eerror "${CATEGORY}/${PF} requires at least one of the following packages:"
				for PYTHON_ABI in "${_CPYTHON2_GLOBALLY_SUPPORTED_ABIS[@]}" "${_CPYTHON3_GLOBALLY_SUPPORTED_ABIS[@]}"; do
					if ! _python_check_python_abi_matching --patterns-list "${PYTHON_ABI}" "${RESTRICT_PYTHON_ABIS}"; then
						eerror "    dev-lang/python:${PYTHON_ABI}"
					fi
				done
				die "No supported version of CPython installed"
			fi

			if [[ -n "${python2_version}" && "${python_version}" == "2."* && "${python_version}" != "${python2_version}" ]]; then
				eerror "Python wrapper is configured incorrectly or '${EPREFIX}/usr/bin/python2' symlink"
				eerror "is set incorrectly. Use \`eselect python\` to fix configuration."
				die "Incorrect configuration of Python"
			fi
			if [[ -n "${python3_version}" && "${python_version}" == "3."* && "${python_version}" != "${python3_version}" ]]; then
				eerror "Python wrapper is configured incorrectly or '${EPREFIX}/usr/bin/python3' symlink"
				eerror "is set incorrectly. Use \`eselect python\` to fix configuration."
				die "Incorrect configuration of Python"
			fi

			PYTHON_ABIS="${python2_version} ${python3_version}"
			PYTHON_ABIS="${PYTHON_ABIS# }"
			export PYTHON_ABIS="${PYTHON_ABIS% }"
		fi
	fi

	_python_final_sanity_checks
}

_python_prepare_flags() {
	local array=() deleted_flag element flags new_value old_flag old_value operator pattern prefix variable

	for variable in CPPFLAGS CFLAGS CXXFLAGS LDFLAGS; do
		eval "_PYTHON_SAVED_${variable}=\"\${!variable}\""
		for prefix in PYTHON_USER_ PYTHON_; do
			if [[ "$(declare -p ${prefix}${variable} 2> /dev/null)" == "declare -a ${prefix}${variable}="* ]]; then
				eval "array=(\"\${${prefix}${variable}[@]}\")"
				for element in "${array[@]}"; do
					if [[ "${element}" =~ ^${_PYTHON_ABI_PATTERN_REGEX}\ (\+|-)\ .+ ]]; then
						pattern="${element%% *}"
						element="${element#* }"
						operator="${element%% *}"
						flags="${element#* }"
						if _python_check_python_abi_matching "${PYTHON_ABI}" "${pattern}"; then
							if [[ "${operator}" == "+" ]]; then
								eval "export ${variable}+=\"\${variable:+ }${flags}\""
							elif [[ "${operator}" == "-" ]]; then
								flags="${flags// /$'\n'}"
								old_value="${!variable// /$'\n'}"
								new_value=""
								while read old_flag; do
									while read deleted_flag; do
										if [[ "${old_flag}" == ${deleted_flag} ]]; then
											continue 2
										fi
									done <<< "${flags}"
									new_value+="${new_value:+ }${old_flag}"
								done <<< "${old_value}"
								eval "export ${variable}=\"\${new_value}\""
							fi
						fi
					else
						die "Element '${element}' of ${prefix}${variable} array has invalid syntax"
					fi
				done
			elif [[ -n "$(declare -p ${prefix}${variable} 2> /dev/null)" ]]; then
				die "${prefix}${variable} should be indexed array"
			fi
		done
	done
}

_python_restore_flags() {
	local variable

	for variable in CPPFLAGS CFLAGS CXXFLAGS LDFLAGS; do
		eval "${variable}=\"\${_PYTHON_SAVED_${variable}}\""
		unset _PYTHON_SAVED_${variable}
	done
}

# @FUNCTION: python_execute_function
# @USAGE: [--action-message message] [-d|--default-function] [--failure-message message] [-f|--final-ABI] [--nonfatal] [-q|--quiet] [-s|--separate-build-dirs] [--source-dir source_directory] [--] <function> [arguments]
# @DESCRIPTION:
# Execute specified function for each value of PYTHON_ABIS, optionally passing additional
# arguments. The specified function can use PYTHON_ABI and BUILDDIR variables.
python_execute_function() {
	if ! _python_package_supporting_installation_for_multiple_python_abis; then
		die "${FUNCNAME}() cannot be used in ebuilds of packages not supporting installation for multiple Python ABIs"
	fi

	_python_check_python_pkg_setup_execution
	_python_set_color_variables

	local action action_message action_message_template default_function="0" failure_message failure_message_template final_ABI="0" function iterated_PYTHON_ABIS nonfatal="0" previous_directory previous_directory_stack previous_directory_stack_length PYTHON_ABI quiet="0" return_code separate_build_dirs="0" source_dir

	while (($#)); do
		case "$1" in
			--action-message)
				action_message_template="$2"
				shift
				;;
			-d|--default-function)
				default_function="1"
				;;
			--failure-message)
				failure_message_template="$2"
				shift
				;;
			-f|--final-ABI)
				final_ABI="1"
				;;
			--nonfatal)
				nonfatal="1"
				;;
			-q|--quiet)
				quiet="1"
				;;
			-s|--separate-build-dirs)
				separate_build_dirs="1"
				;;
			--source-dir)
				source_dir="$2"
				shift
				;;
			--)
				shift
				break
				;;
			-*)
				die "${FUNCNAME}(): Unrecognized option '$1'"
				;;
			*)
				break
				;;
		esac
		shift
	done

	if [[ -n "${source_dir}" && "${separate_build_dirs}" == 0 ]]; then
		die "${FUNCNAME}(): '--source-dir' option can be specified only with '--separate-build-dirs' option"
	fi

	if [[ "${default_function}" == "0" ]]; then
		if [[ "$#" -eq 0 ]]; then
			die "${FUNCNAME}(): Missing function name"
		fi
		function="$1"
		shift

		if [[ -z "$(type -t "${function}")" ]]; then
			die "${FUNCNAME}(): '${function}' function is not defined"
		fi
	else
		if has "${EAPI:-0}" 0 1; then
			die "${FUNCNAME}(): '--default-function' option cannot be used in this EAPI"
		fi

		if [[ "${EBUILD_PHASE}" == "configure" ]]; then
			if has "${EAPI}" 2 3; then
				python_default_function() {
					econf "$@"
				}
			else
				python_default_function() {
					nonfatal econf "$@"
				}
			fi
		elif [[ "${EBUILD_PHASE}" == "compile" ]]; then
			python_default_function() {
				emake "$@"
			}
		elif [[ "${EBUILD_PHASE}" == "test" ]]; then
			python_default_function() {
				# Stolen from portage's _eapi0_src_test()
				local emake_cmd="${MAKE:-make} ${MAKEOPTS} ${EXTRA_EMAKE}"
				if ${emake_cmd} -j1 -n check &> /dev/null; then
					${emake_cmd} -j1 check "$@"
				elif ${emake_cmd} -j1 -n test &> /dev/null; then
					${emake_cmd} -j1 test "$@"
				fi
			}
		elif [[ "${EBUILD_PHASE}" == "install" ]]; then
			python_default_function() {
				emake DESTDIR="${D}" install "$@"
			}
		else
			die "${FUNCNAME}(): '--default-function' option cannot be used in this ebuild phase"
		fi
		function="python_default_function"
	fi

	# Ensure that python_execute_function() cannot be directly or indirectly called by python_execute_function().
	if _python_abi-specific_local_scope; then
		die "${FUNCNAME}(): Invalid call stack"
	fi

	if [[ "${quiet}" == "0" ]]; then
		[[ "${EBUILD_PHASE}" == "setup" ]] && action="Setting up"
		[[ "${EBUILD_PHASE}" == "unpack" ]] && action="Unpacking"
		[[ "${EBUILD_PHASE}" == "prepare" ]] && action="Preparation"
		[[ "${EBUILD_PHASE}" == "configure" ]] && action="Configuration"
		[[ "${EBUILD_PHASE}" == "compile" ]] && action="Building"
		[[ "${EBUILD_PHASE}" == "test" ]] && action="Testing"
		[[ "${EBUILD_PHASE}" == "install" ]] && action="Installation"
		[[ "${EBUILD_PHASE}" == "preinst" ]] && action="Preinstallation"
		[[ "${EBUILD_PHASE}" == "postinst" ]] && action="Postinstallation"
		[[ "${EBUILD_PHASE}" == "prerm" ]] && action="Preuninstallation"
		[[ "${EBUILD_PHASE}" == "postrm" ]] && action="Postuninstallation"
	fi

	_python_calculate_PYTHON_ABIS
	if [[ "${final_ABI}" == "1" ]]; then
		iterated_PYTHON_ABIS="$(PYTHON -f --ABI)"
	else
		iterated_PYTHON_ABIS="${PYTHON_ABIS}"
	fi
	for PYTHON_ABI in ${iterated_PYTHON_ABIS}; do
		if [[ "${EBUILD_PHASE}" == "test" ]] && _python_check_python_abi_matching --patterns-list "${PYTHON_ABI}" "${PYTHON_TESTS_RESTRICTED_ABIS}"; then
			if [[ "${quiet}" == "0" ]]; then
				echo " ${_GREEN}*${_NORMAL} ${_BLUE}Testing of ${CATEGORY}/${PF} with $(python_get_implementation_and_version) skipped${_NORMAL}"
			fi
			continue
		fi

		_python_prepare_flags

		if [[ "${quiet}" == "0" ]]; then
			if [[ -n "${action_message_template}" ]]; then
				eval "action_message=\"${action_message_template}\""
			else
				action_message="${action} of ${CATEGORY}/${PF} with $(python_get_implementation_and_version)..."
			fi
			echo " ${_GREEN}*${_NORMAL} ${_BLUE}${action_message}${_NORMAL}"
		fi

		if [[ "${separate_build_dirs}" == "1" ]]; then
			if [[ -n "${source_dir}" ]]; then
				export BUILDDIR="${S}/${source_dir}-${PYTHON_ABI}"
			else
				export BUILDDIR="${S}-${PYTHON_ABI}"
			fi
			pushd "${BUILDDIR}" > /dev/null || die "pushd failed"
		else
			export BUILDDIR="${S}"
		fi

		previous_directory="$(pwd)"
		previous_directory_stack="$(dirs -p)"
		previous_directory_stack_length="$(dirs -p | wc -l)"

		if ! has "${EAPI}" 0 1 2 3 && has "${PYTHON_ABI}" ${FAILURE_TOLERANT_PYTHON_ABIS}; then
			EPYTHON="$(PYTHON)" nonfatal "${function}" "$@"
		else
			EPYTHON="$(PYTHON)" "${function}" "$@"
		fi

		return_code="$?"

		_python_restore_flags

		if [[ "${return_code}" -ne 0 ]]; then
			if [[ -n "${failure_message_template}" ]]; then
				eval "failure_message=\"${failure_message_template}\""
			else
				failure_message="${action} failed with $(python_get_implementation_and_version) in ${function}() function"
			fi

			if [[ "${nonfatal}" == "1" ]]; then
				if [[ "${quiet}" == "0" ]]; then
					ewarn "${failure_message}"
				fi
			elif [[ "${final_ABI}" == "0" ]] && has "${PYTHON_ABI}" ${FAILURE_TOLERANT_PYTHON_ABIS}; then
				if [[ "${EBUILD_PHASE}" != "test" ]] || ! has test-fail-continue ${FEATURES}; then
					local enabled_PYTHON_ABIS= other_PYTHON_ABI
					for other_PYTHON_ABI in ${PYTHON_ABIS}; do
						[[ "${other_PYTHON_ABI}" != "${PYTHON_ABI}" ]] && enabled_PYTHON_ABIS+="${enabled_PYTHON_ABIS:+ }${other_PYTHON_ABI}"
					done
					export PYTHON_ABIS="${enabled_PYTHON_ABIS}"
				fi
				if [[ "${quiet}" == "0" ]]; then
					ewarn "${failure_message}"
				fi
				if [[ -z "${PYTHON_ABIS}" ]]; then
					die "${function}() function failed with all enabled Python ABIs"
				fi
			else
				die "${failure_message}"
			fi
		fi

		# Ensure that directory stack has not been decreased.
		if [[ "$(dirs -p | wc -l)" -lt "${previous_directory_stack_length}" ]]; then
			die "Directory stack decreased illegally"
		fi

		# Avoid side effects of earlier returning from the specified function.
		while [[ "$(dirs -p | wc -l)" -gt "${previous_directory_stack_length}" ]]; do
			popd > /dev/null || die "popd failed"
		done

		# Ensure that the bottom part of directory stack has not been changed. Restore
		# previous directory (from before running of the specified function) before
		# comparison of directory stacks to avoid mismatch of directory stacks after
		# potential using of 'cd' to change current directory. Restoration of previous
		# directory allows to safely use 'cd' to change current directory in the
		# specified function without changing it back to original directory.
		cd "${previous_directory}"
		if [[ "$(dirs -p)" != "${previous_directory_stack}" ]]; then
			die "Directory stack changed illegally"
		fi

		if [[ "${separate_build_dirs}" == "1" ]]; then
			popd > /dev/null || die "popd failed"
		fi
		unset BUILDDIR
	done

	if [[ "${default_function}" == "1" ]]; then
		unset -f python_default_function
	fi
}

# @FUNCTION: python_copy_sources
# @USAGE: <directory="${S}"> [directory]
# @DESCRIPTION:
# Copy unpacked sources of current package to separate build directory for each Python ABI.
python_copy_sources() {
	if ! _python_package_supporting_installation_for_multiple_python_abis; then
		die "${FUNCNAME}() cannot be used in ebuilds of packages not supporting installation for multiple Python ABIs"
	fi

	_python_check_python_pkg_setup_execution

	local dir dirs=() PYTHON_ABI

	if [[ "$#" -eq 0 ]]; then
		if [[ "${WORKDIR}" == "${S}" ]]; then
			die "${FUNCNAME}() cannot be used with current value of S variable"
		fi
		dirs=("${S%/}")
	else
		dirs=("$@")
	fi

	_python_calculate_PYTHON_ABIS
	for PYTHON_ABI in ${PYTHON_ABIS}; do
		for dir in "${dirs[@]}"; do
			cp -pr "${dir}" "${dir}-${PYTHON_ABI}" > /dev/null || die "Copying of sources failed"
		done
	done
}

# @FUNCTION: python_generate_wrapper_scripts
# @USAGE: [-E|--respect-EPYTHON] [-f|--force] [-q|--quiet] [--] <file> [files]
# @DESCRIPTION:
# Generate wrapper scripts. Existing files are overwritten only with --force option.
# If --respect-EPYTHON option is specified, then generated wrapper scripts will
# respect EPYTHON variable at run time.
#
# This function can be used only in src_install() phase.
python_generate_wrapper_scripts() {
	if [[ "${EBUILD_PHASE}" != "install" ]]; then
		die "${FUNCNAME}() can be used only in src_install() phase"
	fi

	if ! _python_package_supporting_installation_for_multiple_python_abis; then
		die "${FUNCNAME}() cannot be used in ebuilds of packages not supporting installation for multiple Python ABIs"
	fi

	_python_check_python_pkg_setup_execution
	_python_initialize_prefix_variables

	local eselect_python_option file force="0" quiet="0" PYTHON_ABI PYTHON_ABIS_list python2_enabled="0" python3_enabled="0" respect_EPYTHON="0"

	while (($#)); do
		case "$1" in
			-E|--respect-EPYTHON)
				respect_EPYTHON="1"
				;;
			-f|--force)
				force="1"
				;;
			-q|--quiet)
				quiet="1"
				;;
			--)
				shift
				break
				;;
			-*)
				die "${FUNCNAME}(): Unrecognized option '$1'"
				;;
			*)
				break
				;;
		esac
		shift
	done

	if [[ "$#" -eq 0 ]]; then
		die "${FUNCNAME}(): Missing arguments"
	fi

	_python_calculate_PYTHON_ABIS
	for PYTHON_ABI in "${_CPYTHON2_GLOBALLY_SUPPORTED_ABIS[@]}"; do
		if has "${PYTHON_ABI}" ${PYTHON_ABIS}; then
			python2_enabled="1"
		fi
	done
	for PYTHON_ABI in "${_CPYTHON3_GLOBALLY_SUPPORTED_ABIS[@]}"; do
		if has "${PYTHON_ABI}" ${PYTHON_ABIS}; then
			python3_enabled="1"
		fi
	done

	if [[ "${python2_enabled}" == "1" && "${python3_enabled}" == "1" ]]; then
		eselect_python_option=
	elif [[ "${python2_enabled}" == "1" && "${python3_enabled}" == "0" ]]; then
		eselect_python_option="--python2"
	elif [[ "${python2_enabled}" == "0" && "${python3_enabled}" == "1" ]]; then
		eselect_python_option="--python3"
	else
		die "${FUNCNAME}(): Unsupported environment"
	fi

	PYTHON_ABIS_list="$("$(PYTHON -f)" -c "print(', '.join('\"%s\"' % x for x in reversed('${PYTHON_ABIS}'.split())))")"

	for file in "$@"; do
		if [[ -f "${file}" && "${force}" == "0" ]]; then
			die "${FUNCNAME}(): '${file}' already exists"
		fi

		if [[ "${quiet}" == "0" ]]; then
			einfo "Generating '${file#${ED%/}}' wrapper script"
		fi

		cat << EOF > "${file}"
#!/usr/bin/env python
# Gentoo '${file##*/}' wrapper script generated by python_generate_wrapper_scripts()

import os
import re
import subprocess
import sys

cpython_ABI_re = re.compile(r"^(\d+\.\d+)$")
jython_ABI_re = re.compile(r"^(\d+\.\d+)-jython$")
pypy_ABI_re = re.compile(r"^\d+\.\d+-pypy-(\d+\.\d+)$")
cpython_interpreter_re = re.compile(r"^python(\d+\.\d+)$")
jython_interpreter_re = re.compile(r"^jython(\d+\.\d+)$")
pypy_interpreter_re = re.compile(r"^pypy-c(\d+\.\d+)$")
cpython_shebang_re = re.compile(r"^#![ \t]*(?:${EPREFIX}/usr/bin/python|(?:${EPREFIX})?/usr/bin/env[ \t]+(?:${EPREFIX}/usr/bin/)?python)")
python_shebang_options_re = re.compile(r"^#![ \t]*${EPREFIX}/usr/bin/(?:jython|pypy-c|python)(?:\d+(?:\.\d+)?)?[ \t]+(-\S)")
python_verification_output_re = re.compile("^GENTOO_PYTHON_TARGET_SCRIPT_PATH supported\n$")

#pypy_versions_mapping = {
#	"1.5": "2.7",
#	"1.6": "2.7",
#	"1.7": "2.7",
#	"1.8": "2.7",
#	"1.9": "2.7",
#	"2.0": "2.7",
#}

def get_PYTHON_ABI(python_interpreter):
	cpython_matched = cpython_interpreter_re.match(python_interpreter)
	jython_matched = jython_interpreter_re.match(python_interpreter)
	pypy_matched = pypy_interpreter_re.match(python_interpreter)
	if cpython_matched is not None:
		PYTHON_ABI = cpython_matched.group(1)
	elif jython_matched is not None:
		PYTHON_ABI = jython_matched.group(1) + "-jython"
	elif pypy_matched is not None:
		#PYTHON_ABI = pypy_versions_mapping[pypy_matched.group(1)] + "-pypy-" + pypy_matched.group(1)
		PYTHON_ABI = "2.7-pypy-" + pypy_matched.group(1)
	else:
		PYTHON_ABI = None
	return PYTHON_ABI

def get_python_interpreter(PYTHON_ABI):
	cpython_matched = cpython_ABI_re.match(PYTHON_ABI)
	jython_matched = jython_ABI_re.match(PYTHON_ABI)
	pypy_matched = pypy_ABI_re.match(PYTHON_ABI)
	if cpython_matched is not None:
		python_interpreter = "python" + cpython_matched.group(1)
	elif jython_matched is not None:
		python_interpreter = "jython" + jython_matched.group(1)
	elif pypy_matched is not None:
		python_interpreter = "pypy-c" + pypy_matched.group(1)
	else:
		python_interpreter = None
	return python_interpreter

EOF
		if [[ "$?" != "0" ]]; then
			die "${FUNCNAME}(): Generation of '$1' failed"
		fi
		if [[ "${respect_EPYTHON}" == "1" ]]; then
			cat << EOF >> "${file}"
python_interpreter = os.environ.get("EPYTHON")
if python_interpreter:
	PYTHON_ABI = get_PYTHON_ABI(python_interpreter)
	if PYTHON_ABI is None:
		sys.stderr.write("%s: EPYTHON variable has unrecognized value '%s'\n" % (sys.argv[0], python_interpreter))
		sys.exit(1)
else:
	try:
		environment = os.environ.copy()
		environment["ROOT"] = "/"
		eselect_process = subprocess.Popen(["${EPREFIX}/usr/bin/eselect", "python", "show"${eselect_python_option:+, $(echo "\"")}${eselect_python_option}${eselect_python_option:+$(echo "\"")}], env=environment, stdout=subprocess.PIPE)
		if eselect_process.wait() != 0:
			raise ValueError
	except (OSError, ValueError):
		sys.stderr.write("%s: Execution of 'eselect python show${eselect_python_option:+ }${eselect_python_option}' failed\n" % sys.argv[0])
		sys.exit(1)

	python_interpreter = eselect_process.stdout.read()
	if not isinstance(python_interpreter, str):
		# Python 3
		python_interpreter = python_interpreter.decode()
	python_interpreter = python_interpreter.rstrip("\n")

	PYTHON_ABI = get_PYTHON_ABI(python_interpreter)
	if PYTHON_ABI is None:
		sys.stderr.write("%s: 'eselect python show${eselect_python_option:+ }${eselect_python_option}' printed unrecognized value '%s'\n" % (sys.argv[0], python_interpreter))
		sys.exit(1)

wrapper_script_path = os.path.realpath(sys.argv[0])
target_executable_path = "%s-%s" % (wrapper_script_path, PYTHON_ABI)
if not os.path.exists(target_executable_path):
	sys.stderr.write("%s: '%s' does not exist\n" % (sys.argv[0], target_executable_path))
	sys.exit(1)
EOF
			if [[ "$?" != "0" ]]; then
				die "${FUNCNAME}(): Generation of '$1' failed"
			fi
		else
			cat << EOF >> "${file}"
try:
	environment = os.environ.copy()
	environment["ROOT"] = "/"
	eselect_process = subprocess.Popen(["${EPREFIX}/usr/bin/eselect", "python", "show"${eselect_python_option:+, $(echo "\"")}${eselect_python_option}${eselect_python_option:+$(echo "\"")}], env=environment, stdout=subprocess.PIPE)
	if eselect_process.wait() != 0:
		raise ValueError
except (OSError, ValueError):
	sys.stderr.write("%s: Execution of 'eselect python show${eselect_python_option:+ }${eselect_python_option}' failed\n" % sys.argv[0])
	sys.exit(1)

python_interpreter = eselect_process.stdout.read()
if not isinstance(python_interpreter, str):
	# Python 3
	python_interpreter = python_interpreter.decode()
python_interpreter = python_interpreter.rstrip("\n")

PYTHON_ABI = get_PYTHON_ABI(python_interpreter)
if PYTHON_ABI is None:
	sys.stderr.write("%s: 'eselect python show${eselect_python_option:+ }${eselect_python_option}' printed unrecognized value '%s'\n" % (sys.argv[0], python_interpreter))
	sys.exit(1)

wrapper_script_path = os.path.realpath(sys.argv[0])
for PYTHON_ABI in [PYTHON_ABI, ${PYTHON_ABIS_list}]:
	target_executable_path = "%s-%s" % (wrapper_script_path, PYTHON_ABI)
	if os.path.exists(target_executable_path):
		break
else:
	sys.stderr.write("%s: No target script exists for '%s'\n" % (sys.argv[0], wrapper_script_path))
	sys.exit(1)

python_interpreter = get_python_interpreter(PYTHON_ABI)
if python_interpreter is None:
	sys.stderr.write("%s: Unrecognized Python ABI '%s'\n" % (sys.argv[0], PYTHON_ABI))
	sys.exit(1)
EOF
			if [[ "$?" != "0" ]]; then
				die "${FUNCNAME}(): Generation of '$1' failed"
			fi
		fi
		cat << EOF >> "${file}"

target_executable = open(target_executable_path, "rb")
target_executable_first_line = target_executable.readline()
target_executable.close()
if not isinstance(target_executable_first_line, str):
	# Python 3
	target_executable_first_line = target_executable_first_line.decode("utf_8", "replace")

options = []
python_shebang_options_matched = python_shebang_options_re.match(target_executable_first_line)
if python_shebang_options_matched is not None:
	options = [python_shebang_options_matched.group(1)]

cpython_shebang_matched = cpython_shebang_re.match(target_executable_first_line)

if cpython_shebang_matched is not None:
	try:
		python_interpreter_path = "${EPREFIX}/usr/bin/%s" % python_interpreter
		os.environ["GENTOO_PYTHON_TARGET_SCRIPT_PATH_VERIFICATION"] = "1"
		python_verification_process = subprocess.Popen([python_interpreter_path, "-c", "pass"], stdout=subprocess.PIPE)
		del os.environ["GENTOO_PYTHON_TARGET_SCRIPT_PATH_VERIFICATION"]
		if python_verification_process.wait() != 0:
			raise ValueError

		python_verification_output = python_verification_process.stdout.read()
		if not isinstance(python_verification_output, str):
			# Python 3
			python_verification_output = python_verification_output.decode()

		if not python_verification_output_re.match(python_verification_output):
			raise ValueError

		if cpython_interpreter_re.match(python_interpreter) is not None:
			os.environ["GENTOO_PYTHON_PROCESS_NAME"] = os.path.basename(sys.argv[0])
			os.environ["GENTOO_PYTHON_WRAPPER_SCRIPT_PATH"] = sys.argv[0]
			os.environ["GENTOO_PYTHON_TARGET_SCRIPT_PATH"] = target_executable_path

		if hasattr(os, "execv"):
			os.execv(python_interpreter_path, [python_interpreter_path] + options + sys.argv)
		else:
			sys.exit(subprocess.Popen([python_interpreter_path] + options + sys.argv).wait())
	except (KeyboardInterrupt, SystemExit):
		raise
	except:
		pass
	for variable in ("GENTOO_PYTHON_PROCESS_NAME", "GENTOO_PYTHON_WRAPPER_SCRIPT_PATH", "GENTOO_PYTHON_TARGET_SCRIPT_PATH", "GENTOO_PYTHON_TARGET_SCRIPT_PATH_VERIFICATION"):
		if variable in os.environ:
			del os.environ[variable]

if hasattr(os, "execv"):
	os.execv(target_executable_path, sys.argv)
else:
	sys.exit(subprocess.Popen([target_executable_path] + sys.argv[1:]).wait())
EOF
		if [[ "$?" != "0" ]]; then
			die "${FUNCNAME}(): Generation of '$1' failed"
		fi
		fperms +x "${file#${ED%/}}" || die "fperms '${file}' failed"
	done
}

# @ECLASS-VARIABLE: PYTHON_VERSIONED_SCRIPTS
# @DESCRIPTION:
# Array of regular expressions of paths to versioned Python scripts.
# Python scripts in /usr/bin and /usr/sbin are versioned by default.

# @ECLASS-VARIABLE: PYTHON_VERSIONED_EXECUTABLES
# @DESCRIPTION:
# Array of regular expressions of paths to versioned executables (including Python scripts).

# @ECLASS-VARIABLE: PYTHON_NONVERSIONED_EXECUTABLES
# @DESCRIPTION:
# Array of regular expressions of paths to nonversioned executables (including Python scripts).

# @FUNCTION: python_merge_intermediate_installation_images
# @USAGE: [-q|--quiet] [--] <intermediate_installation_images_directory>
# @DESCRIPTION:
# Merge intermediate installation images into installation image.
#
# This function can be used only in src_install() phase.
python_merge_intermediate_installation_images() {
	if [[ "${EBUILD_PHASE}" != "install" ]]; then
		die "${FUNCNAME}() can be used only in src_install() phase"
	fi

	if ! _python_package_supporting_installation_for_multiple_python_abis; then
		die "${FUNCNAME}() cannot be used in ebuilds of packages not supporting installation for multiple Python ABIs"
	fi

	_python_check_python_pkg_setup_execution
	_python_initialize_prefix_variables

	local absolute_file b file files=() intermediate_installation_images_directory PYTHON_ABI quiet="0" regex shebang version_executable wrapper_scripts=() wrapper_scripts_set=()

	while (($#)); do
		case "$1" in
			-q|--quiet)
				quiet="1"
				;;
			--)
				shift
				break
				;;
			-*)
				die "${FUNCNAME}(): Unrecognized option '$1'"
				;;
			*)
				break
				;;
		esac
		shift
	done

	if [[ "$#" -ne 1 ]]; then
		die "${FUNCNAME}() requires 1 argument"
	fi

	intermediate_installation_images_directory="$1"

	if [[ ! -d "${intermediate_installation_images_directory}" ]]; then
		die "${FUNCNAME}(): Intermediate installation images directory '${intermediate_installation_images_directory}' does not exist"
	fi

	_python_calculate_PYTHON_ABIS
	if [[ "$(PYTHON -f --ABI)" == 3.* ]]; then
		b="b"
	fi

	while read -d $'\0' -r file; do
		files+=("${file}")
	done < <("$(PYTHON -f)" -c \
"import os
import sys

if hasattr(sys.stdout, 'buffer'):
	# Python 3
	stdout = sys.stdout.buffer
else:
	# Python 2
	stdout = sys.stdout

files_set = set()

os.chdir(${b}'${intermediate_installation_images_directory}')

for PYTHON_ABI in ${b}'${PYTHON_ABIS}'.split():
	for root, dirs, files in os.walk(PYTHON_ABI + ${b}'${EPREFIX}'):
		root = root[len(PYTHON_ABI + ${b}'${EPREFIX}')+1:]
		files_set.update(root + ${b}'/' + file for file in files)

for file in sorted(files_set):
	stdout.write(file)
	stdout.write(${b}'\x00')" || die "${FUNCNAME}(): Failure of extraction of files in intermediate installation images")

	for PYTHON_ABI in ${PYTHON_ABIS}; do
		if [[ ! -d "${intermediate_installation_images_directory}/${PYTHON_ABI}" ]]; then
			die "${FUNCNAME}(): Intermediate installation image for Python ABI '${PYTHON_ABI}' does not exist"
		fi

		pushd "${intermediate_installation_images_directory}/${PYTHON_ABI}${EPREFIX}" > /dev/null || die "pushd failed"

		for file in "${files[@]}"; do
			version_executable="0"
			for regex in "/usr/bin/.*" "/usr/sbin/.*" "${PYTHON_VERSIONED_SCRIPTS[@]}"; do
				if [[ "/${file}" =~ ^${regex}$ ]]; then
					version_executable="1"
					break
				fi
			done
			for regex in "${PYTHON_VERSIONED_EXECUTABLES[@]}"; do
				if [[ "/${file}" =~ ^${regex}$ ]]; then
					version_executable="2"
					break
				fi
			done
			if [[ "${version_executable}" != "0" ]]; then
				for regex in "${PYTHON_NONVERSIONED_EXECUTABLES[@]}"; do
					if [[ "/${file}" =~ ^${regex}$ ]]; then
						version_executable="0"
						break
					fi
				done
			fi

			[[ "${version_executable}" == "0" ]] && continue

			if [[ -L "${file}" ]]; then
				absolute_file="$(readlink "${file}")"
				if [[ "${absolute_file}" == /* ]]; then
					absolute_file="${intermediate_installation_images_directory}/${PYTHON_ABI}${EPREFIX}/${absolute_file##/}"
				else
					if [[ "${file}" == */* ]]; then
						absolute_file="${intermediate_installation_images_directory}/${PYTHON_ABI}${EPREFIX}/${file%/*}/${absolute_file}"
					else
						absolute_file="${intermediate_installation_images_directory}/${PYTHON_ABI}${EPREFIX}/${absolute_file}"
					fi
				fi
			else
				absolute_file="${intermediate_installation_images_directory}/${PYTHON_ABI}${EPREFIX}/${file}"
			fi

			[[ ! -x "${absolute_file}" ]] && continue

			shebang="$(head -n1 "${absolute_file}")" || die "Extraction of shebang from '${absolute_file}' failed"

			if [[ "${version_executable}" == "2" ]]; then
				wrapper_scripts+=("${ED}${file}")
			elif [[ "${version_executable}" == "1" ]]; then
				if [[ "${shebang}" =~ ${_PYTHON_SHEBANG_BASE_PART_REGEX}([[:digit:]]+(\.[[:digit:]]+)?)?($|[[:space:]]+) ]]; then
					wrapper_scripts+=("${ED}${file}")
				else
					version_executable="0"
				fi
			fi

			[[ "${version_executable}" == "0" ]] && continue

			if [[ -e "${file}-${PYTHON_ABI}" ]]; then
				die "${FUNCNAME}(): '${EPREFIX}/${file}-${PYTHON_ABI}' already exists"
			fi

			mv "${file}" "${file}-${PYTHON_ABI}" || die "Renaming of '${file}' failed"

			if [[ "${shebang}" =~ ${_PYTHON_SHEBANG_BASE_PART_REGEX}[[:digit:]]*($|[[:space:]]+) ]]; then
				if [[ -L "${file}-${PYTHON_ABI}" ]]; then
					python_convert_shebangs $([[ "${quiet}" == "1" ]] && echo --quiet) "${PYTHON_ABI}" "${absolute_file}"
				else
					python_convert_shebangs $([[ "${quiet}" == "1" ]] && echo --quiet) "${PYTHON_ABI}" "${file}-${PYTHON_ABI}"
				fi
			fi
		done

		popd > /dev/null || die "popd failed"

		# This is per bug #390691, without the duplication refactor, and with
		# the 3-way structure per comment #6. This enable users with old
		# coreutils to upgrade a lot easier (you need to upgrade python+portage
		# before coreutils can be upgraded).
		if ROOT="/" has_version '>=sys-apps/coreutils-6.9.90'; then
			cp -fr --preserve=all --no-preserve=context "${intermediate_installation_images_directory}/${PYTHON_ABI}/"* "${D}" || die "Merging of intermediate installation image for Python ABI '${PYTHON_ABI} into installation image failed"
		elif ROOT="/" has_version sys-apps/coreutils; then
			cp -fr --preserve=all "${intermediate_installation_images_directory}/${PYTHON_ABI}/"* "${D}" || die "Merging of intermediate installation image for Python ABI '${PYTHON_ABI} into installation image failed"
		else
			cp -fpr "${intermediate_installation_images_directory}/${PYTHON_ABI}/"* "${D}" || die "Merging of intermediate installation image for Python ABI '${PYTHON_ABI} into installation image failed"
		fi
	done

	rm -fr "${intermediate_installation_images_directory}"

	if [[ "${#wrapper_scripts[@]}" -ge 1 ]]; then
		rm -f "${T}/python_wrapper_scripts"

		for file in "${wrapper_scripts[@]}"; do
			echo -n "${file}" >> "${T}/python_wrapper_scripts"
			echo -en "\x00" >> "${T}/python_wrapper_scripts"
		done

		while read -d $'\0' -r file; do
			wrapper_scripts_set+=("${file}")
		done < <("$(PYTHON -f)" -c \
"import sys

if hasattr(sys.stdout, 'buffer'):
	# Python 3
	stdout = sys.stdout.buffer
else:
	# Python 2
	stdout = sys.stdout

python_wrapper_scripts_file = open('${T}/python_wrapper_scripts', 'rb')
files = set(python_wrapper_scripts_file.read().rstrip(${b}'\x00').split(${b}'\x00'))
python_wrapper_scripts_file.close()

for file in sorted(files):
	stdout.write(file)
	stdout.write(${b}'\x00')" || die "${FUNCNAME}(): Failure of extraction of set of wrapper scripts")

		python_generate_wrapper_scripts $([[ "${quiet}" == "1" ]] && echo --quiet) "${wrapper_scripts_set[@]}"
	fi
}

# ================================================================================================
# ========= FUNCTIONS FOR PACKAGES NOT SUPPORTING INSTALLATION FOR MULTIPLE PYTHON ABIS ==========
# ================================================================================================

unset EPYTHON PYTHON_ABI

# @FUNCTION: python_set_active_version
# @USAGE: <Python_ABI|2|3>
# @DESCRIPTION:
# Set locally active version of Python.
# If Python_ABI argument is specified, then version of Python corresponding to Python_ABI is used.
# If 2 argument is specified, then active version of CPython 2 is used.
# If 3 argument is specified, then active version of CPython 3 is used.
#
# This function can be used only in pkg_setup() phase.
python_set_active_version() {
	if [[ "${EBUILD_PHASE}" != "setup" ]]; then
		die "${FUNCNAME}() can be used only in pkg_setup() phase"
	fi

	if _python_package_supporting_installation_for_multiple_python_abis; then
		die "${FUNCNAME}() cannot be used in ebuilds of packages supporting installation for multiple Python ABIs"
	fi

	if [[ "$#" -ne 1 ]]; then
		die "${FUNCNAME}() requires 1 argument"
	fi

	_python_initial_sanity_checks

	if [[ -z "${PYTHON_ABI}" ]]; then
		if [[ -n "$(_python_get_implementation --ignore-invalid "$1")" ]]; then
			# PYTHON_ABI variable is intended to be used only in ebuilds/eclasses,
			# so it does not need to be exported to subprocesses.
			PYTHON_ABI="$1"
			if ! _python_implementation && ! has_version "$(python_get_implementational_package)"; then
				die "${FUNCNAME}(): '$(python_get_implementational_package)' is not installed"
			fi
			export EPYTHON="$(PYTHON "$1")"
		elif [[ "$1" == "2" ]]; then
			if ! _python_implementation && ! has_version "=dev-lang/python-2*"; then
				die "${FUNCNAME}(): '=dev-lang/python-2*' is not installed"
			fi
			export EPYTHON="$(PYTHON -2)"
			PYTHON_ABI="${EPYTHON#python}"
			PYTHON_ABI="${PYTHON_ABI%%-*}"
		elif [[ "$1" == "3" ]]; then
			if ! _python_implementation && ! has_version "=dev-lang/python-3*"; then
				die "${FUNCNAME}(): '=dev-lang/python-3*' is not installed"
			fi
			export EPYTHON="$(PYTHON -3)"
			PYTHON_ABI="${EPYTHON#python}"
			PYTHON_ABI="${PYTHON_ABI%%-*}"
		else
			die "${FUNCNAME}(): Unrecognized argument '$1'"
		fi
	fi

	_python_final_sanity_checks

	# python-updater checks PYTHON_REQUESTED_ACTIVE_VERSION variable.
	PYTHON_REQUESTED_ACTIVE_VERSION="$1"
}

# @FUNCTION: python_need_rebuild
# @DESCRIPTION:
# Mark current package for rebuilding by python-updater after
# switching of active version of Python.
python_need_rebuild() {
	if _python_package_supporting_installation_for_multiple_python_abis; then
		die "${FUNCNAME}() cannot be used in ebuilds of packages supporting installation for multiple Python ABIs"
	fi

	_python_check_python_pkg_setup_execution

	if [[ "$#" -ne 0 ]]; then
		die "${FUNCNAME}() does not accept arguments"
	fi

	export PYTHON_NEED_REBUILD="$(PYTHON --ABI)"
}

# ================================================================================================
# ======================================= GETTER FUNCTIONS =======================================
# ================================================================================================

_PYTHON_ABI_EXTRACTION_COMMAND=\
'import platform
import sys
sys.stdout.write(".".join(str(x) for x in sys.version_info[:2]))
if platform.system()[:4] == "Java":
	sys.stdout.write("-jython")
elif hasattr(platform, "python_implementation") and platform.python_implementation() == "PyPy":
	sys.stdout.write("-pypy-" + ".".join(str(x) for x in sys.pypy_version_info[:2]))'

_python_get_implementation() {
	local ignore_invalid="0"

	while (($#)); do
		case "$1" in
			--ignore-invalid)
				ignore_invalid="1"
				;;
			--)
				shift
				break
				;;
			-*)
				die "${FUNCNAME}(): Unrecognized option '$1'"
				;;
			*)
				break
				;;
		esac
		shift
	done

	if [[ "$#" -ne 1 ]]; then
		die "${FUNCNAME}() requires 1 argument"
	fi

	if [[ "$1" =~ ^[[:digit:]]+\.[[:digit:]]+$ ]]; then
		echo "CPython"
	elif [[ "$1" =~ ^[[:digit:]]+\.[[:digit:]]+-jython$ ]]; then
		echo "Jython"
	elif [[ "$1" =~ ^[[:digit:]]+\.[[:digit:]]+-pypy-[[:digit:]]+\.[[:digit:]]+$ ]]; then
		echo "PyPy"
	else
		if [[ "${ignore_invalid}" == "0" ]]; then
			die "${FUNCNAME}(): Unrecognized Python ABI '$1'"
		fi
	fi
}

# @FUNCTION: PYTHON
# @USAGE: [-2] [-3] [--ABI] [-a|--absolute-path] [-f|--final-ABI] [--] <Python_ABI="${PYTHON_ABI}">
# @DESCRIPTION:
# Print filename of Python interpreter for specified Python ABI. If Python_ABI argument
# is ommitted, then PYTHON_ABI environment variable must be set and is used.
# If -2 option is specified, then active version of CPython 2 is used.
# If -3 option is specified, then active version of CPython 3 is used.
# If --final-ABI option is specified, then final ABI from the list of enabled ABIs is used.
# -2, -3 and --final-ABI options and Python_ABI argument cannot be specified simultaneously.
# If --ABI option is specified, then only specified Python ABI is printed instead of
# filename of Python interpreter.
# If --absolute-path option is specified, then absolute path to Python interpreter is printed.
# --ABI and --absolute-path options cannot be specified simultaneously.
PYTHON() {
	_python_check_python_pkg_setup_execution

	local ABI_output="0" absolute_path_output="0" final_ABI="0" PYTHON_ABI="${PYTHON_ABI}" python_interpreter python2="0" python3="0"

	while (($#)); do
		case "$1" in
			-2)
				python2="1"
				;;
			-3)
				python3="1"
				;;
			--ABI)
				ABI_output="1"
				;;
			-a|--absolute-path)
				absolute_path_output="1"
				;;
			-f|--final-ABI)
				final_ABI="1"
				;;
			--)
				shift
				break
				;;
			-*)
				die "${FUNCNAME}(): Unrecognized option '$1'"
				;;
			*)
				break
				;;
		esac
		shift
	done

	if [[ "${ABI_output}" == "1" && "${absolute_path_output}" == "1" ]]; then
		die "${FUNCNAME}(): '--ABI' and '--absolute-path' options cannot be specified simultaneously"
	fi

	if [[ "$((${python2} + ${python3} + ${final_ABI}))" -gt 1 ]]; then
		die "${FUNCNAME}(): '-2', '-3' or '--final-ABI' options cannot be specified simultaneously"
	fi

	if [[ "$#" -eq 0 ]]; then
		if [[ "${final_ABI}" == "1" ]]; then
			if ! _python_package_supporting_installation_for_multiple_python_abis; then
				die "${FUNCNAME}(): '--final-ABI' option cannot be used in ebuilds of packages not supporting installation for multiple Python ABIs"
			fi
			_python_calculate_PYTHON_ABIS
			PYTHON_ABI="${PYTHON_ABIS##* }"
		elif [[ "${python2}" == "1" ]]; then
			PYTHON_ABI="$(ROOT="/" eselect python show --python2 --ABI)"
			if [[ -z "${PYTHON_ABI}" ]]; then
				die "${FUNCNAME}(): Active version of CPython 2 not set"
			elif [[ "${PYTHON_ABI}" != "2."* ]]; then
				die "${FUNCNAME}(): Internal error in \`eselect python show --python2\`"
			fi
		elif [[ "${python3}" == "1" ]]; then
			PYTHON_ABI="$(ROOT="/" eselect python show --python3 --ABI)"
			if [[ -z "${PYTHON_ABI}" ]]; then
				die "${FUNCNAME}(): Active version of CPython 3 not set"
			elif [[ "${PYTHON_ABI}" != "3."* ]]; then
				die "${FUNCNAME}(): Internal error in \`eselect python show --python3\`"
			fi
		elif _python_package_supporting_installation_for_multiple_python_abis; then
			if ! _python_abi-specific_local_scope; then
				die "${FUNCNAME}() should be used in ABI-specific local scope"
			fi
		else
			PYTHON_ABI="$("${EPREFIX}/usr/bin/python" -c "${_PYTHON_ABI_EXTRACTION_COMMAND}")"
			if [[ -z "${PYTHON_ABI}" ]]; then
				die "${FUNCNAME}(): Failure of extraction of locally active version of Python"
			fi
		fi
	elif [[ "$#" -eq 1 ]]; then
		if [[ "${final_ABI}" == "1" ]]; then
			die "${FUNCNAME}(): '--final-ABI' option and Python ABI cannot be specified simultaneously"
		fi
		if [[ "${python2}" == "1" ]]; then
			die "${FUNCNAME}(): '-2' option and Python ABI cannot be specified simultaneously"
		fi
		if [[ "${python3}" == "1" ]]; then
			die "${FUNCNAME}(): '-3' option and Python ABI cannot be specified simultaneously"
		fi
		PYTHON_ABI="$1"
	else
		die "${FUNCNAME}(): Invalid usage"
	fi

	if [[ "${ABI_output}" == "1" ]]; then
		echo -n "${PYTHON_ABI}"
		return
	else
		if [[ "$(_python_get_implementation "${PYTHON_ABI}")" == "CPython" ]]; then
			python_interpreter="python${PYTHON_ABI}"
		elif [[ "$(_python_get_implementation "${PYTHON_ABI}")" == "Jython" ]]; then
			python_interpreter="jython${PYTHON_ABI%-jython}"
		elif [[ "$(_python_get_implementation "${PYTHON_ABI}")" == "PyPy" ]]; then
			python_interpreter="pypy-c${PYTHON_ABI#*-pypy-}"
		fi

		if [[ "${absolute_path_output}" == "1" ]]; then
			echo -n "${EPREFIX}/usr/bin/${python_interpreter}"
		else
			echo -n "${python_interpreter}"
		fi
	fi

	if [[ -n "${ABI}" && "${ABI}" != "${DEFAULT_ABI}" && "${DEFAULT_ABI}" != "default" ]]; then
		echo -n "-${ABI}"
	fi
}

# @FUNCTION: python_get_implementation
# @USAGE: [-f|--final-ABI]
# @DESCRIPTION:
# Print name of Python implementation.
# If --final-ABI option is specified, then final ABI from the list of enabled ABIs is used.
python_get_implementation() {
	_python_check_python_pkg_setup_execution

	local final_ABI="0" PYTHON_ABI="${PYTHON_ABI}"

	while (($#)); do
		case "$1" in
			-f|--final-ABI)
				final_ABI="1"
				;;
			-*)
				die "${FUNCNAME}(): Unrecognized option '$1'"
				;;
			*)
				die "${FUNCNAME}(): Invalid usage"
				;;
		esac
		shift
	done

	if [[ "${final_ABI}" == "1" ]]; then
		if ! _python_package_supporting_installation_for_multiple_python_abis; then
			die "${FUNCNAME}(): '--final-ABI' option cannot be used in ebuilds of packages not supporting installation for multiple Python ABIs"
		fi
		PYTHON_ABI="$(PYTHON -f --ABI)"
	else
		if _python_package_supporting_installation_for_multiple_python_abis; then
			if ! _python_abi-specific_local_scope; then
				die "${FUNCNAME}() should be used in ABI-specific local scope"
			fi
		else
			PYTHON_ABI="${PYTHON_ABI:-$(PYTHON --ABI)}"
		fi
	fi

	echo "$(_python_get_implementation "${PYTHON_ABI}")"
}

# @FUNCTION: python_get_implementational_package
# @USAGE: [-f|--final-ABI]
# @DESCRIPTION:
# Print category, name and slot of package providing Python implementation.
# If --final-ABI option is specified, then final ABI from the list of enabled ABIs is used.
python_get_implementational_package() {
	_python_check_python_pkg_setup_execution

	local final_ABI="0" PYTHON_ABI="${PYTHON_ABI}"

	while (($#)); do
		case "$1" in
			-f|--final-ABI)
				final_ABI="1"
				;;
			-*)
				die "${FUNCNAME}(): Unrecognized option '$1'"
				;;
			*)
				die "${FUNCNAME}(): Invalid usage"
				;;
		esac
		shift
	done

	if [[ "${final_ABI}" == "1" ]]; then
		if ! _python_package_supporting_installation_for_multiple_python_abis; then
			die "${FUNCNAME}(): '--final-ABI' option cannot be used in ebuilds of packages not supporting installation for multiple Python ABIs"
		fi
		PYTHON_ABI="$(PYTHON -f --ABI)"
	else
		if _python_package_supporting_installation_for_multiple_python_abis; then
			if ! _python_abi-specific_local_scope; then
				die "${FUNCNAME}() should be used in ABI-specific local scope"
			fi
		else
			PYTHON_ABI="${PYTHON_ABI:-$(PYTHON --ABI)}"
		fi
	fi

	if [[ "${EAPI:-0}" == "0" ]]; then
		if [[ "$(_python_get_implementation "${PYTHON_ABI}")" == "CPython" ]]; then
			echo "=dev-lang/python-${PYTHON_ABI}*"
		elif [[ "$(_python_get_implementation "${PYTHON_ABI}")" == "Jython" ]]; then
			echo "=dev-java/jython-${PYTHON_ABI%-jython}*"
		elif [[ "$(_python_get_implementation "${PYTHON_ABI}")" == "PyPy" ]]; then
			echo "=virtual/pypy-${PYTHON_ABI#*-pypy-}*"
		fi
	else
		if [[ "$(_python_get_implementation "${PYTHON_ABI}")" == "CPython" ]]; then
			echo "dev-lang/python:${PYTHON_ABI}"
		elif [[ "$(_python_get_implementation "${PYTHON_ABI}")" == "Jython" ]]; then
			echo "dev-java/jython:${PYTHON_ABI%-jython}"
		elif [[ "$(_python_get_implementation "${PYTHON_ABI}")" == "PyPy" ]]; then
			echo "virtual/pypy:${PYTHON_ABI#*-pypy-}"
		fi
	fi
}

# @FUNCTION: python_get_includedir
# @USAGE: [-b|--base-path] [-f|--final-ABI]
# @DESCRIPTION:
# Print path to Python include directory.
# If --base-path option is specified, then path not prefixed with "/" is printed.
# If --final-ABI option is specified, then final ABI from the list of enabled ABIs is used.
python_get_includedir() {
	_python_check_python_pkg_setup_execution

	local base_path="0" final_ABI="0" prefix PYTHON_ABI="${PYTHON_ABI}"

	while (($#)); do
		case "$1" in
			-b|--base-path)
				base_path="1"
				;;
			-f|--final-ABI)
				final_ABI="1"
				;;
			-*)
				die "${FUNCNAME}(): Unrecognized option '$1'"
				;;
			*)
				die "${FUNCNAME}(): Invalid usage"
				;;
		esac
		shift
	done

	if [[ "${base_path}" == "0" ]]; then
		prefix="/"
	fi

	if [[ "${final_ABI}" == "1" ]]; then
		if ! _python_package_supporting_installation_for_multiple_python_abis; then
			die "${FUNCNAME}(): '--final-ABI' option cannot be used in ebuilds of packages not supporting installation for multiple Python ABIs"
		fi
		PYTHON_ABI="$(PYTHON -f --ABI)"
	else
		if _python_package_supporting_installation_for_multiple_python_abis; then
			if ! _python_abi-specific_local_scope; then
				die "${FUNCNAME}() should be used in ABI-specific local scope"
			fi
		else
			PYTHON_ABI="${PYTHON_ABI:-$(PYTHON --ABI)}"
		fi
	fi

	if [[ "$(_python_get_implementation "${PYTHON_ABI}")" == "CPython" ]]; then
		echo "${prefix}usr/include/python${PYTHON_ABI}"
	elif [[ "$(_python_get_implementation "${PYTHON_ABI}")" == "Jython" ]]; then
		echo "${prefix}usr/share/jython-${PYTHON_ABI%-jython}/Include"
	elif [[ "$(_python_get_implementation "${PYTHON_ABI}")" == "PyPy" ]]; then
		echo "${prefix}usr/$(get_libdir)/pypy${PYTHON_ABI#*-pypy-}/include"
	fi
}

# @FUNCTION: python_get_libdir
# @USAGE: [-b|--base-path] [-f|--final-ABI]
# @DESCRIPTION:
# Print path to Python standard library directory.
# If --base-path option is specified, then path not prefixed with "/" is printed.
# If --final-ABI option is specified, then final ABI from the list of enabled ABIs is used.
python_get_libdir() {
	_python_check_python_pkg_setup_execution

	local base_path="0" final_ABI="0" prefix PYTHON_ABI="${PYTHON_ABI}"

	while (($#)); do
		case "$1" in
			-b|--base-path)
				base_path="1"
				;;
			-f|--final-ABI)
				final_ABI="1"
				;;
			-*)
				die "${FUNCNAME}(): Unrecognized option '$1'"
				;;
			*)
				die "${FUNCNAME}(): Invalid usage"
				;;
		esac
		shift
	done

	if [[ "${base_path}" == "0" ]]; then
		prefix="/"
	fi

	if [[ "${final_ABI}" == "1" ]]; then
		if ! _python_package_supporting_installation_for_multiple_python_abis; then
			die "${FUNCNAME}(): '--final-ABI' option cannot be used in ebuilds of packages not supporting installation for multiple Python ABIs"
		fi
		PYTHON_ABI="$(PYTHON -f --ABI)"
	else
		if _python_package_supporting_installation_for_multiple_python_abis; then
			if ! _python_abi-specific_local_scope; then
				die "${FUNCNAME}() should be used in ABI-specific local scope"
			fi
		else
			PYTHON_ABI="${PYTHON_ABI:-$(PYTHON --ABI)}"
		fi
	fi

	if [[ "$(_python_get_implementation "${PYTHON_ABI}")" == "CPython" ]]; then
		echo "${prefix}usr/$(get_libdir)/python${PYTHON_ABI}"
	elif [[ "$(_python_get_implementation "${PYTHON_ABI}")" == "Jython" ]]; then
		echo "${prefix}usr/share/jython-${PYTHON_ABI%-jython}/Lib"
	elif [[ "$(_python_get_implementation "${PYTHON_ABI}")" == "PyPy" ]]; then
		die "${FUNCNAME}(): PyPy has multiple standard library directories"
	fi
}

# @FUNCTION: python_get_sitedir
# @USAGE: [-b|--base-path] [-f|--final-ABI]
# @DESCRIPTION:
# Print path to Python site-packages directory.
# If --base-path option is specified, then path not prefixed with "/" is printed.
# If --final-ABI option is specified, then final ABI from the list of enabled ABIs is used.
python_get_sitedir() {
	_python_check_python_pkg_setup_execution

	local base_path="0" final_ABI="0" prefix PYTHON_ABI="${PYTHON_ABI}"

	while (($#)); do
		case "$1" in
			-b|--base-path)
				base_path="1"
				;;
			-f|--final-ABI)
				final_ABI="1"
				;;
			-*)
				die "${FUNCNAME}(): Unrecognized option '$1'"
				;;
			*)
				die "${FUNCNAME}(): Invalid usage"
				;;
		esac
		shift
	done

	if [[ "${base_path}" == "0" ]]; then
		prefix="/"
	fi

	if [[ "${final_ABI}" == "1" ]]; then
		if ! _python_package_supporting_installation_for_multiple_python_abis; then
			die "${FUNCNAME}(): '--final-ABI' option cannot be used in ebuilds of packages not supporting installation for multiple Python ABIs"
		fi
		PYTHON_ABI="$(PYTHON -f --ABI)"
	else
		if _python_package_supporting_installation_for_multiple_python_abis; then
			if ! _python_abi-specific_local_scope; then
				die "${FUNCNAME}() should be used in ABI-specific local scope"
			fi
		else
			PYTHON_ABI="${PYTHON_ABI:-$(PYTHON --ABI)}"
		fi
	fi

	if [[ "$(_python_get_implementation "${PYTHON_ABI}")" == "CPython" ]]; then
		echo "${prefix}usr/$(get_libdir)/python${PYTHON_ABI}/site-packages"
	elif [[ "$(_python_get_implementation "${PYTHON_ABI}")" == "Jython" ]]; then
		echo "${prefix}usr/share/jython-${PYTHON_ABI%-jython}/Lib/site-packages"
	elif [[ "$(_python_get_implementation "${PYTHON_ABI}")" == "PyPy" ]]; then
		echo "${prefix}usr/$(get_libdir)/pypy${PYTHON_ABI#*-pypy-}/site-packages"
	fi
}

# @FUNCTION: python_get_library
# @USAGE: [-b|--base-path] [-f|--final-ABI] [-l|--linker-option]
# @DESCRIPTION:
# Print path to Python library.
# If --base-path option is specified, then path not prefixed with "/" is printed.
# If --linker-option is specified, then "-l${library}" linker option is printed.
# If --final-ABI option is specified, then final ABI from the list of enabled ABIs is used.
python_get_library() {
	_python_check_python_pkg_setup_execution

	local base_path="0" final_ABI="0" linker_option="0" prefix PYTHON_ABI="${PYTHON_ABI}"

	while (($#)); do
		case "$1" in
			-b|--base-path)
				base_path="1"
				;;
			-f|--final-ABI)
				final_ABI="1"
				;;
			-l|--linker-option)
				linker_option="1"
				;;
			-*)
				die "${FUNCNAME}(): Unrecognized option '$1'"
				;;
			*)
				die "${FUNCNAME}(): Invalid usage"
				;;
		esac
		shift
	done

	if [[ "${base_path}" == "0" ]]; then
		prefix="/"
	fi

	if [[ "${base_path}" == "1" && "${linker_option}" == "1" ]]; then
		die "${FUNCNAME}(): '--base-path' and '--linker-option' options cannot be specified simultaneously"
	fi

	if [[ "${final_ABI}" == "1" ]]; then
		if ! _python_package_supporting_installation_for_multiple_python_abis; then
			die "${FUNCNAME}(): '--final-ABI' option cannot be used in ebuilds of packages not supporting installation for multiple Python ABIs"
		fi
		PYTHON_ABI="$(PYTHON -f --ABI)"
	else
		if _python_package_supporting_installation_for_multiple_python_abis; then
			if ! _python_abi-specific_local_scope; then
				die "${FUNCNAME}() should be used in ABI-specific local scope"
			fi
		else
			PYTHON_ABI="${PYTHON_ABI:-$(PYTHON --ABI)}"
		fi
	fi

	if [[ "$(_python_get_implementation "${PYTHON_ABI}")" == "CPython" ]]; then
		if [[ "${linker_option}" == "1" ]]; then
			echo "-lpython${PYTHON_ABI}"
		else
			echo "${prefix}usr/$(get_libdir)/libpython${PYTHON_ABI}$(get_libname)"
		fi
	elif [[ "$(_python_get_implementation "${PYTHON_ABI}")" == "Jython" ]]; then
		die "${FUNCNAME}(): Jython does not have shared library"
	elif [[ "$(_python_get_implementation "${PYTHON_ABI}")" == "PyPy" ]]; then
		die "${FUNCNAME}(): PyPy does not have shared library"
	fi
}

# @FUNCTION: python_get_version
# @USAGE: [-f|--final-ABI] [-l|--language] [--full] [--major] [--minor] [--micro]
# @DESCRIPTION:
# Print version of Python implementation.
# --full, --major, --minor and --micro options cannot be specified simultaneously.
# If --full, --major, --minor and --micro options are not specified, then "${major_version}.${minor_version}" is printed.
# If --language option is specified, then version of Python language is printed.
# --language and --full options cannot be specified simultaneously.
# --language and --micro options cannot be specified simultaneously.
# If --final-ABI option is specified, then final ABI from the list of enabled ABIs is used.
python_get_version() {
	_python_check_python_pkg_setup_execution

	local final_ABI="0" language="0" language_version full="0" major="0" minor="0" micro="0" PYTHON_ABI="${PYTHON_ABI}" python_command

	while (($#)); do
		case "$1" in
			-f|--final-ABI)
				final_ABI="1"
				;;
			-l|--language)
				language="1"
				;;
			--full)
				full="1"
				;;
			--major)
				major="1"
				;;
			--minor)
				minor="1"
				;;
			--micro)
				micro="1"
				;;
			-*)
				die "${FUNCNAME}(): Unrecognized option '$1'"
				;;
			*)
				die "${FUNCNAME}(): Invalid usage"
				;;
		esac
		shift
	done

	if [[ "${final_ABI}" == "1" ]]; then
		if ! _python_package_supporting_installation_for_multiple_python_abis; then
			die "${FUNCNAME}(): '--final-ABI' option cannot be used in ebuilds of packages not supporting installation for multiple Python ABIs"
		fi
	else
		if _python_package_supporting_installation_for_multiple_python_abis && ! _python_abi-specific_local_scope; then
			die "${FUNCNAME}() should be used in ABI-specific local scope"
		fi
	fi

	if [[ "$((${full} + ${major} + ${minor} + ${micro}))" -gt 1 ]]; then
		die "${FUNCNAME}(): '--full', '--major', '--minor' or '--micro' options cannot be specified simultaneously"
	fi

	if [[ "${language}" == "1" ]]; then
		if [[ "${final_ABI}" == "1" ]]; then
			PYTHON_ABI="$(PYTHON -f --ABI)"
		elif [[ -z "${PYTHON_ABI}" ]]; then
			PYTHON_ABI="$(PYTHON --ABI)"
		fi
		language_version="${PYTHON_ABI%%-*}"
		if [[ "${full}" == "1" ]]; then
			die "${FUNCNAME}(): '--language' and '--full' options cannot be specified simultaneously"
		elif [[ "${major}" == "1" ]]; then
			echo "${language_version%.*}"
		elif [[ "${minor}" == "1" ]]; then
			echo "${language_version#*.}"
		elif [[ "${micro}" == "1" ]]; then
			die "${FUNCNAME}(): '--language' and '--micro' options cannot be specified simultaneously"
		else
			echo "${language_version}"
		fi
	else
		if [[ "${full}" == "1" ]]; then
			python_command="import sys; print('.'.join(str(x) for x in getattr(sys, 'pypy_version_info', sys.version_info)[:3]))"
		elif [[ "${major}" == "1" ]]; then
			python_command="import sys; print(getattr(sys, 'pypy_version_info', sys.version_info)[0])"
		elif [[ "${minor}" == "1" ]]; then
			python_command="import sys; print(getattr(sys, 'pypy_version_info', sys.version_info)[1])"
		elif [[ "${micro}" == "1" ]]; then
			python_command="import sys; print(getattr(sys, 'pypy_version_info', sys.version_info)[2])"
		else
			if [[ -n "${PYTHON_ABI}" && "${final_ABI}" == "0" ]]; then
				if [[ "$(_python_get_implementation "${PYTHON_ABI}")" == "CPython" ]]; then
					echo "${PYTHON_ABI}"
				elif [[ "$(_python_get_implementation "${PYTHON_ABI}")" == "Jython" ]]; then
					echo "${PYTHON_ABI%-jython}"
				elif [[ "$(_python_get_implementation "${PYTHON_ABI}")" == "PyPy" ]]; then
					echo "${PYTHON_ABI#*-pypy-}"
				fi
				return
			fi
			python_command="from sys import version_info; print('.'.join(str(x) for x in version_info[:2]))"
		fi

		if [[ "${final_ABI}" == "1" ]]; then
			"$(PYTHON -f)" -c "${python_command}"
		else
			"$(PYTHON ${PYTHON_ABI})" -c "${python_command}"
		fi
	fi
}

# @FUNCTION: python_get_implementation_and_version
# @USAGE: [-f|--final-ABI]
# @DESCRIPTION:
# Print name and version of Python implementation.
# If version of Python implementation is not bound to version of Python language, then
# version of Python language is additionally printed.
# If --final-ABI option is specified, then final ABI from the list of enabled ABIs is used.
python_get_implementation_and_version() {
	_python_check_python_pkg_setup_execution

	local final_ABI="0" PYTHON_ABI="${PYTHON_ABI}"

	while (($#)); do
		case "$1" in
			-f|--final-ABI)
				final_ABI="1"
				;;
			-*)
				die "${FUNCNAME}(): Unrecognized option '$1'"
				;;
			*)
				die "${FUNCNAME}(): Invalid usage"
				;;
		esac
		shift
	done

	if [[ "${final_ABI}" == "1" ]]; then
		if ! _python_package_supporting_installation_for_multiple_python_abis; then
			die "${FUNCNAME}(): '--final-ABI' option cannot be used in ebuilds of packages not supporting installation for multiple Python ABIs"
		fi
		PYTHON_ABI="$(PYTHON -f --ABI)"
	else
		if _python_package_supporting_installation_for_multiple_python_abis; then
			if ! _python_abi-specific_local_scope; then
				die "${FUNCNAME}() should be used in ABI-specific local scope"
			fi
		else
			PYTHON_ABI="${PYTHON_ABI:-$(PYTHON --ABI)}"
		fi
	fi

	if [[ "${PYTHON_ABI}" =~ ^[[:digit:]]+\.[[:digit:]]+-[[:alnum:]]+-[[:digit:]]+\.[[:digit:]]+$ ]]; then
		echo "$(_python_get_implementation "${PYTHON_ABI}") ${PYTHON_ABI##*-} (Python ${PYTHON_ABI%%-*})"
	else
		echo "$(_python_get_implementation "${PYTHON_ABI}") ${PYTHON_ABI%%-*}"
	fi
}

# ================================================================================================
# ================================ FUNCTIONS FOR RUNNING OF TESTS ================================
# ================================================================================================

# @ECLASS-VARIABLE: PYTHON_TEST_VERBOSITY
# @DESCRIPTION:
# User-configurable verbosity of tests of Python modules.
# Supported values: 0, 1, 2, 3, 4.
PYTHON_TEST_VERBOSITY="${PYTHON_TEST_VERBOSITY:-1}"

_python_test_hook() {
	if [[ "$#" -ne 1 ]]; then
		die "${FUNCNAME}() requires 1 argument"
	fi

	if _python_package_supporting_installation_for_multiple_python_abis && [[ "$(type -t "${_PYTHON_TEST_FUNCTION}_$1_hook")" == "function" ]]; then
		"${_PYTHON_TEST_FUNCTION}_$1_hook"
	fi
}

# @FUNCTION: python_execute_nosetests
# @USAGE: [-P|--PYTHONPATH PYTHONPATH] [-s|--separate-build-dirs] [--] [arguments]
# @DESCRIPTION:
# Execute nosetests for all enabled Python ABIs.
# In ebuilds of packages supporting installation for multiple Python ABIs, this function calls
# python_execute_nosetests_pre_hook() and python_execute_nosetests_post_hook(), if they are defined.
python_execute_nosetests() {
	_python_check_python_pkg_setup_execution
	_python_set_color_variables

	local PYTHONPATH_template separate_build_dirs

	while (($#)); do
		case "$1" in
			-P|--PYTHONPATH)
				PYTHONPATH_template="$2"
				shift
				;;
			-s|--separate-build-dirs)
				separate_build_dirs="1"
				;;
			--)
				shift
				break
				;;
			-*)
				die "${FUNCNAME}(): Unrecognized option '$1'"
				;;
			*)
				break
				;;
		esac
		shift
	done

	python_test_function() {
		local evaluated_PYTHONPATH

		eval "evaluated_PYTHONPATH=\"${PYTHONPATH_template}\""

		_PYTHON_TEST_FUNCTION="python_execute_nosetests" _python_test_hook pre

		if [[ -n "${evaluated_PYTHONPATH}" ]]; then
			echo ${_BOLD}PYTHONPATH="${evaluated_PYTHONPATH}" nosetests --verbosity="${PYTHON_TEST_VERBOSITY}" "$@"${_NORMAL}
			PYTHONPATH="${evaluated_PYTHONPATH}" nosetests --verbosity="${PYTHON_TEST_VERBOSITY}" "$@" || return "$?"
		else
			echo ${_BOLD}nosetests --verbosity="${PYTHON_TEST_VERBOSITY}" "$@"${_NORMAL}
			nosetests --verbosity="${PYTHON_TEST_VERBOSITY}" "$@" || return "$?"
		fi

		_PYTHON_TEST_FUNCTION="python_execute_nosetests" _python_test_hook post
	}
	if _python_package_supporting_installation_for_multiple_python_abis; then
		python_execute_function ${separate_build_dirs:+-s} python_test_function "$@"
	else
		if [[ -n "${separate_build_dirs}" ]]; then
			die "${FUNCNAME}(): Invalid usage"
		fi
		python_test_function "$@" || die "Testing failed"
	fi

	unset -f python_test_function
}

# @FUNCTION: python_execute_py.test
# @USAGE: [-P|--PYTHONPATH PYTHONPATH] [-s|--separate-build-dirs] [--] [arguments]
# @DESCRIPTION:
# Execute py.test for all enabled Python ABIs.
# In ebuilds of packages supporting installation for multiple Python ABIs, this function calls
# python_execute_py.test_pre_hook() and python_execute_py.test_post_hook(), if they are defined.
python_execute_py.test() {
	_python_check_python_pkg_setup_execution
	_python_set_color_variables

	local PYTHONPATH_template separate_build_dirs

	while (($#)); do
		case "$1" in
			-P|--PYTHONPATH)
				PYTHONPATH_template="$2"
				shift
				;;
			-s|--separate-build-dirs)
				separate_build_dirs="1"
				;;
			--)
				shift
				break
				;;
			-*)
				die "${FUNCNAME}(): Unrecognized option '$1'"
				;;
			*)
				break
				;;
		esac
		shift
	done

	python_test_function() {
		local evaluated_PYTHONPATH

		eval "evaluated_PYTHONPATH=\"${PYTHONPATH_template}\""

		_PYTHON_TEST_FUNCTION="python_execute_py.test" _python_test_hook pre

		if [[ -n "${evaluated_PYTHONPATH}" ]]; then
			echo ${_BOLD}PYTHONPATH="${evaluated_PYTHONPATH}" py.test $([[ "${PYTHON_TEST_VERBOSITY}" -ge 2 ]] && echo -v) "$@"${_NORMAL}
			PYTHONPATH="${evaluated_PYTHONPATH}" py.test $([[ "${PYTHON_TEST_VERBOSITY}" -ge 2 ]] && echo -v) "$@" || return "$?"
		else
			echo ${_BOLD}py.test $([[ "${PYTHON_TEST_VERBOSITY}" -gt 1 ]] && echo -v) "$@"${_NORMAL}
			py.test $([[ "${PYTHON_TEST_VERBOSITY}" -gt 1 ]] && echo -v) "$@" || return "$?"
		fi

		_PYTHON_TEST_FUNCTION="python_execute_py.test" _python_test_hook post
	}
	if _python_package_supporting_installation_for_multiple_python_abis; then
		python_execute_function ${separate_build_dirs:+-s} python_test_function "$@"
	else
		if [[ -n "${separate_build_dirs}" ]]; then
			die "${FUNCNAME}(): Invalid usage"
		fi
		python_test_function "$@" || die "Testing failed"
	fi

	unset -f python_test_function
}

# @FUNCTION: python_execute_trial
# @USAGE: [-P|--PYTHONPATH PYTHONPATH] [-s|--separate-build-dirs] [--] [arguments]
# @DESCRIPTION:
# Execute trial for all enabled Python ABIs.
# In ebuilds of packages supporting installation for multiple Python ABIs, this function
# calls python_execute_trial_pre_hook() and python_execute_trial_post_hook(), if they are defined.
python_execute_trial() {
	_python_check_python_pkg_setup_execution
	_python_set_color_variables

	local PYTHONPATH_template separate_build_dirs

	while (($#)); do
		case "$1" in
			-P|--PYTHONPATH)
				PYTHONPATH_template="$2"
				shift
				;;
			-s|--separate-build-dirs)
				separate_build_dirs="1"
				;;
			--)
				shift
				break
				;;
			-*)
				die "${FUNCNAME}(): Unrecognized option '$1'"
				;;
			*)
				break
				;;
		esac
		shift
	done

	python_test_function() {
		local evaluated_PYTHONPATH

		eval "evaluated_PYTHONPATH=\"${PYTHONPATH_template}\""

		_PYTHON_TEST_FUNCTION="python_execute_trial" _python_test_hook pre

		if [[ -n "${evaluated_PYTHONPATH}" ]]; then
			echo ${_BOLD}PYTHONPATH="${evaluated_PYTHONPATH}" trial $([[ "${PYTHON_TEST_VERBOSITY}" -ge 4 ]] && echo --spew) "$@"${_NORMAL}
			PYTHONPATH="${evaluated_PYTHONPATH}" trial $([[ "${PYTHON_TEST_VERBOSITY}" -ge 4 ]] && echo --spew) "$@" || return "$?"
		else
			echo ${_BOLD}trial $([[ "${PYTHON_TEST_VERBOSITY}" -ge 4 ]] && echo --spew) "$@"${_NORMAL}
			trial $([[ "${PYTHON_TEST_VERBOSITY}" -ge 4 ]] && echo --spew) "$@" || return "$?"
		fi

		_PYTHON_TEST_FUNCTION="python_execute_trial" _python_test_hook post
	}
	if _python_package_supporting_installation_for_multiple_python_abis; then
		python_execute_function ${separate_build_dirs:+-s} python_test_function "$@"
	else
		if [[ -n "${separate_build_dirs}" ]]; then
			die "${FUNCNAME}(): Invalid usage"
		fi
		python_test_function "$@" || die "Testing failed"
	fi

	unset -f python_test_function
}

# ================================================================================================
# ======================= FUNCTIONS FOR HANDLING OF BYTE-COMPILED MODULES ========================
# ================================================================================================

# @FUNCTION: python_enable_pyc
# @DESCRIPTION:
# Tell Python to automatically recompile modules to .pyc/.pyo if the
# timestamps/version stamps have changed.
python_enable_pyc() {
	_python_check_python_pkg_setup_execution

	if [[ "$#" -ne 0 ]]; then
		die "${FUNCNAME}() does not accept arguments"
	fi

	unset PYTHONDONTWRITEBYTECODE
}

# @FUNCTION: python_disable_pyc
# @DESCRIPTION:
# Tell Python not to automatically recompile modules to .pyc/.pyo
# even if the timestamps/version stamps do not match. This is done
# to protect sandbox.
python_disable_pyc() {
	_python_check_python_pkg_setup_execution

	if [[ "$#" -ne 0 ]]; then
		die "${FUNCNAME}() does not accept arguments"
	fi

	export PYTHONDONTWRITEBYTECODE="1"
}

_python_vecho() {
	[[ -z ${PORTAGE_VERBOSE} ]] || echo "$@"
}

_python_clean_compiled_modules() {
	_python_initialize_prefix_variables
	_python_set_color_variables

	[[ "${FUNCNAME[1]}" =~ ^(python_mod_optimize|python_mod_cleanup)$ ]] || die "${FUNCNAME}(): Invalid usage"

	local base_module_name compiled_file compiled_files=() dir path py_file root

	# Strip trailing slash from EROOT.
	root="${EROOT%/}"

	for path in "$@"; do
		compiled_files=()
		if [[ -d "${path}" ]]; then
			while read -d $'\0' -r compiled_file; do
				compiled_files+=("${compiled_file}")
			done < <(find "${path}" "(" -name "*.py[co]" -o -name "*\$py.class" ")" -print0)

			if [[ "${EBUILD_PHASE}" == "postrm" ]]; then
				# Delete empty child directories.
				find "${path}" -type d | sort -r | while read -r dir; do
					if rmdir "${dir}" 2> /dev/null; then
						_python_vecho "<<< ${dir}"
					fi
				done
			fi
		elif [[ "${path}" == *.py ]]; then
			base_module_name="${path##*/}"
			base_module_name="${base_module_name%.py}"
			if [[ -d "${path%/*}/__pycache__" ]]; then
				while read -d $'\0' -r compiled_file; do
					compiled_files+=("${compiled_file}")
				done < <(find "${path%/*}/__pycache__" "(" -name "${base_module_name}.*.py[co]" -o -name "${base_module_name}\$py.class" ")" -print0)
			fi
			compiled_files+=("${path}c" "${path}o" "${path%.py}\$py.class")
		fi

		for compiled_file in "${compiled_files[@]}"; do
			[[ ! -f "${compiled_file}" ]] && continue
			dir="${compiled_file%/*}"
			dir="${dir##*/}"
			if [[ "${compiled_file}" == *.py[co] ]]; then
				if [[ "${dir}" == "__pycache__" ]]; then
					base_module_name="${compiled_file##*/}"
					base_module_name="${base_module_name%.*py[co]}"
					base_module_name="${base_module_name%.*}"
					py_file="${compiled_file%__pycache__/*}${base_module_name}.py"
				else
					py_file="${compiled_file%[co]}"
				fi
				if [[ "${EBUILD_PHASE}" == "postinst" ]]; then
					[[ -f "${py_file}" && "${compiled_file}" -nt "${py_file}" ]] && continue
				else
					[[ -f "${py_file}" ]] && continue
				fi
				_python_vecho "<<< ${compiled_file%[co]}[co]"
				rm -f "${compiled_file%[co]}"[co]
			elif [[ "${compiled_file}" == *\$py.class ]]; then
				if [[ "${dir}" == "__pycache__" ]]; then
					base_module_name="${compiled_file##*/}"
					base_module_name="${base_module_name%\$py.class}"
					py_file="${compiled_file%__pycache__/*}${base_module_name}.py"
				else
					py_file="${compiled_file%\$py.class}.py"
				fi
				if [[ "${EBUILD_PHASE}" == "postinst" ]]; then
					[[ -f "${py_file}" && "${compiled_file}" -nt "${py_file}" ]] && continue
				else
					[[ -f "${py_file}" ]] && continue
				fi
				_python_vecho "<<< ${compiled_file}"
				rm -f "${compiled_file}"
			else
				die "${FUNCNAME}(): Unrecognized file type: '${compiled_file}'"
			fi

			# Delete empty parent directories.
			dir="${compiled_file%/*}"
			while [[ "${dir}" != "${root}" ]]; do
				if rmdir "${dir}" 2> /dev/null; then
					_python_vecho "<<< ${dir}"
				else
					break
				fi
				dir="${dir%/*}"
			done
		done
	done
}

# @FUNCTION: python_mod_optimize
# @USAGE: [--allow-evaluated-non-sitedir-paths] [-d directory] [-f] [-l] [-q] [-x regular_expression] [--] <file|directory> [files|directories]
# @DESCRIPTION:
# Byte-compile specified Python modules.
# -d, -f, -l, -q and -x options passed to this function are passed to compileall.py.
#
# This function can be used only in pkg_postinst() phase.
python_mod_optimize() {
	if [[ "${EBUILD_PHASE}" != "postinst" ]]; then
		die "${FUNCNAME}() can be used only in pkg_postinst() phase"
	fi

	_python_check_python_pkg_setup_execution
	_python_initialize_prefix_variables

	if ! has "${EAPI:-0}" 0 1 2 || _python_package_supporting_installation_for_multiple_python_abis || _python_implementation || [[ "${CATEGORY}/${PN}" == "sys-apps/portage" ]]; then
		# PYTHON_ABI variable cannot be local in packages not supporting installation for multiple Python ABIs.
		local allow_evaluated_non_sitedir_paths="0" dir dirs=() evaluated_dirs=() evaluated_files=() file files=() iterated_PYTHON_ABIS options=() other_dirs=() other_files=() previous_PYTHON_ABI="${PYTHON_ABI}" return_code root site_packages_dirs=() site_packages_files=() stderr stderr_line

		if _python_package_supporting_installation_for_multiple_python_abis; then
			if has "${EAPI:-0}" 0 1 2 3 && [[ -z "${PYTHON_ABIS}" ]]; then
				die "${FUNCNAME}(): python_pkg_setup() or python_execute_function() not called"
			fi
			iterated_PYTHON_ABIS="${PYTHON_ABIS}"
		else
			if has "${EAPI:-0}" 0 1 2 3; then
				iterated_PYTHON_ABIS="${PYTHON_ABI:=$(PYTHON --ABI)}"
			else
				iterated_PYTHON_ABIS="${PYTHON_ABI}"
			fi
		fi

		# Strip trailing slash from EROOT.
		root="${EROOT%/}"

		while (($#)); do
			case "$1" in
				--allow-evaluated-non-sitedir-paths)
					allow_evaluated_non_sitedir_paths="1"
					;;
				-l|-f|-q)
					options+=("$1")
					;;
				-d|-x)
					options+=("$1" "$2")
					shift
					;;
				--)
					shift
					break
					;;
				-*)
					die "${FUNCNAME}(): Unrecognized option '$1'"
					;;
				*)
					break
					;;
			esac
			shift
		done

		if [[ "${allow_evaluated_non_sitedir_paths}" == "1" ]] && ! _python_package_supporting_installation_for_multiple_python_abis; then
			die "${FUNCNAME}(): '--allow-evaluated-non-sitedir-paths' option cannot be used in ebuilds of packages not supporting installation for multiple Python ABIs"
		fi

		if [[ "$#" -eq 0 ]]; then
			die "${FUNCNAME}(): Missing files or directories"
		fi

		while (($#)); do
			if [[ "$1" =~ ^($|(\.|\.\.|/)($|/)) ]]; then
				die "${FUNCNAME}(): Invalid argument '$1'"
			elif ! _python_implementation && [[ "$1" =~ ^/usr/lib(32|64)?/python[[:digit:]]+\.[[:digit:]]+ ]]; then
				die "${FUNCNAME}(): Paths of directories / files in site-packages directories must be relative to site-packages directories"
			elif [[ "$1" =~ ^/ ]]; then
				if _python_package_supporting_installation_for_multiple_python_abis; then
					if [[ "${allow_evaluated_non_sitedir_paths}" != "1" ]]; then
						die "${FUNCNAME}(): Absolute paths cannot be used in ebuilds of packages supporting installation for multiple Python ABIs"
					fi
					if [[ "$1" != *\$* ]]; then
						die "${FUNCNAME}(): '$1' has invalid syntax"
					fi
					if [[ "$1" == *.py ]]; then
						evaluated_files+=("$1")
					else
						evaluated_dirs+=("$1")
					fi
				else
					if [[ -d "${root}$1" ]]; then
						other_dirs+=("${root}$1")
					elif [[ -f "${root}$1" ]]; then
						other_files+=("${root}$1")
					elif [[ -e "${root}$1" ]]; then
						eerror "${FUNCNAME}(): '${root}$1' is not a regular file or a directory"
					else
						eerror "${FUNCNAME}(): '${root}$1' does not exist"
					fi
				fi
			else
				for PYTHON_ABI in ${iterated_PYTHON_ABIS}; do
					if [[ -d "${root}$(python_get_sitedir)/$1" ]]; then
						site_packages_dirs+=("$1")
						break
					elif [[ -f "${root}$(python_get_sitedir)/$1" ]]; then
						site_packages_files+=("$1")
						break
					elif [[ -e "${root}$(python_get_sitedir)/$1" ]]; then
						eerror "${FUNCNAME}(): '$1' is not a regular file or a directory"
					else
						eerror "${FUNCNAME}(): '$1' does not exist"
					fi
				done
			fi
			shift
		done

		# Set additional options.
		options+=("-q")

		for PYTHON_ABI in ${iterated_PYTHON_ABIS}; do
			if ((${#site_packages_dirs[@]})) || ((${#site_packages_files[@]})) || ((${#evaluated_dirs[@]})) || ((${#evaluated_files[@]})); then
				return_code="0"
				stderr=""
				ebegin "Compilation and optimization of Python modules for $(python_get_implementation_and_version)"
				if ((${#site_packages_dirs[@]})) || ((${#evaluated_dirs[@]})); then
					for dir in "${site_packages_dirs[@]}"; do
						dirs+=("${root}$(python_get_sitedir)/${dir}")
					done
					for dir in "${evaluated_dirs[@]}"; do
						eval "dirs+=(\"\${root}${dir}\")"
					done
					stderr+="${stderr:+$'\n'}$("$(PYTHON)" -m compileall "${options[@]}" "${dirs[@]}" 2>&1)" || return_code="1"
					if ! has "$(_python_get_implementation "${PYTHON_ABI}")" Jython PyPy; then
						"$(PYTHON)" -O -m compileall "${options[@]}" "${dirs[@]}" &> /dev/null || return_code="1"
					fi
					_python_clean_compiled_modules "${dirs[@]}"
				fi
				if ((${#site_packages_files[@]})) || ((${#evaluated_files[@]})); then
					for file in "${site_packages_files[@]}"; do
						files+=("${root}$(python_get_sitedir)/${file}")
					done
					for file in "${evaluated_files[@]}"; do
						eval "files+=(\"\${root}${file}\")"
					done
					stderr+="${stderr:+$'\n'}$("$(PYTHON)" -m py_compile "${files[@]}" 2>&1)" || return_code="1"
					if ! has "$(_python_get_implementation "${PYTHON_ABI}")" Jython PyPy; then
						"$(PYTHON)" -O -m py_compile "${files[@]}" &> /dev/null || return_code="1"
					fi
					_python_clean_compiled_modules "${files[@]}"
				fi
				eend "${return_code}"
				if [[ -n "${stderr}" ]]; then
					eerror "Syntax errors / warnings in Python modules for $(python_get_implementation_and_version):" &> /dev/null
					while read stderr_line; do
						eerror "    ${stderr_line}"
					done <<< "${stderr}"
				fi
			fi
			unset dirs files
		done

		if _python_package_supporting_installation_for_multiple_python_abis; then
			# Restore previous value of PYTHON_ABI.
			if [[ -n "${previous_PYTHON_ABI}" ]]; then
				PYTHON_ABI="${previous_PYTHON_ABI}"
			else
				unset PYTHON_ABI
			fi
		fi

		if ((${#other_dirs[@]})) || ((${#other_files[@]})); then
			return_code="0"
			stderr=""
			ebegin "Compilation and optimization of Python modules placed outside of site-packages directories for $(python_get_implementation_and_version)"
			if ((${#other_dirs[@]})); then
				stderr+="${stderr:+$'\n'}$("$(PYTHON ${PYTHON_ABI})" -m compileall "${options[@]}" "${other_dirs[@]}" 2>&1)" || return_code="1"
				if ! has "$(_python_get_implementation "${PYTHON_ABI}")" Jython PyPy; then
					"$(PYTHON ${PYTHON_ABI})" -O -m compileall "${options[@]}" "${other_dirs[@]}" &> /dev/null || return_code="1"
				fi
				_python_clean_compiled_modules "${other_dirs[@]}"
			fi
			if ((${#other_files[@]})); then
				stderr+="${stderr:+$'\n'}$("$(PYTHON ${PYTHON_ABI})" -m py_compile "${other_files[@]}" 2>&1)" || return_code="1"
				if ! has "$(_python_get_implementation "${PYTHON_ABI}")" Jython PyPy; then
					"$(PYTHON ${PYTHON_ABI})" -O -m py_compile "${other_files[@]}" &> /dev/null || return_code="1"
				fi
				_python_clean_compiled_modules "${other_files[@]}"
			fi
			eend "${return_code}"
			if [[ -n "${stderr}" ]]; then
				eerror "Syntax errors / warnings in Python modules placed outside of site-packages directories for $(python_get_implementation_and_version):" &> /dev/null
				while read stderr_line; do
					eerror "    ${stderr_line}"
				done <<< "${stderr}"
			fi
		fi
	else
		# Deprecated part of python_mod_optimize()

		local myroot mydirs=() myfiles=() myopts=() return_code="0"

		# strip trailing slash
		myroot="${EROOT%/}"

		# respect EROOT and options passed to compileall.py
		while (($#)); do
			case "$1" in
				-l|-f|-q)
					myopts+=("$1")
					;;
				-d|-x)
					myopts+=("$1" "$2")
					shift
					;;
				--)
					shift
					break
					;;
				-*)
					die "${FUNCNAME}(): Unrecognized option '$1'"
					;;
				*)
					break
					;;
			esac
			shift
		done

		if [[ "$#" -eq 0 ]]; then
			die "${FUNCNAME}(): Missing files or directories"
		fi

		while (($#)); do
			if [[ "$1" =~ ^($|(\.|\.\.|/)($|/)) ]]; then
				die "${FUNCNAME}(): Invalid argument '$1'"
			elif [[ -d "${myroot}/${1#/}" ]]; then
				mydirs+=("${myroot}/${1#/}")
			elif [[ -f "${myroot}/${1#/}" ]]; then
				myfiles+=("${myroot}/${1#/}")
			elif [[ -e "${myroot}/${1#/}" ]]; then
				eerror "${FUNCNAME}(): ${myroot}/${1#/} is not a regular file or directory"
			else
				eerror "${FUNCNAME}(): ${myroot}/${1#/} does not exist"
			fi
			shift
		done

		# set additional opts
		myopts+=(-q)

		PYTHON_ABI="${PYTHON_ABI:-$(PYTHON --ABI)}"

		ebegin "Compilation and optimization of Python modules for $(python_get_implementation) $(python_get_version)"
		if ((${#mydirs[@]})); then
			"$(PYTHON ${PYTHON_ABI})" "${myroot}$(python_get_libdir)/compileall.py" "${myopts[@]}" "${mydirs[@]}" || return_code="1"
			"$(PYTHON ${PYTHON_ABI})" -O "${myroot}$(python_get_libdir)/compileall.py" "${myopts[@]}" "${mydirs[@]}" &> /dev/null || return_code="1"
			_python_clean_compiled_modules "${mydirs[@]}"
		fi

		if ((${#myfiles[@]})); then
			"$(PYTHON ${PYTHON_ABI})" "${myroot}$(python_get_libdir)/py_compile.py" "${myfiles[@]}" || return_code="1"
			"$(PYTHON ${PYTHON_ABI})" -O "${myroot}$(python_get_libdir)/py_compile.py" "${myfiles[@]}" &> /dev/null || return_code="1"
			_python_clean_compiled_modules "${myfiles[@]}"
		fi

		eend "${return_code}"
	fi
}

# @FUNCTION: python_mod_cleanup
# @USAGE: [--allow-evaluated-non-sitedir-paths] [--] <file|directory> [files|directories]
# @DESCRIPTION:
# Delete orphaned byte-compiled Python modules corresponding to specified Python modules.
#
# This function can be used only in pkg_postrm() phase.
python_mod_cleanup() {
	if [[ "${EBUILD_PHASE}" != "postrm" ]]; then
		die "${FUNCNAME}() can be used only in pkg_postrm() phase"
	fi

	_python_check_python_pkg_setup_execution
	_python_initialize_prefix_variables

	local allow_evaluated_non_sitedir_paths="0" dir iterated_PYTHON_ABIS PYTHON_ABI="${PYTHON_ABI}" root search_paths=() sitedir

	if _python_package_supporting_installation_for_multiple_python_abis; then
		if has "${EAPI:-0}" 0 1 2 3 && [[ -z "${PYTHON_ABIS}" ]]; then
			die "${FUNCNAME}(): python_pkg_setup() or python_execute_function() not called"
		fi
		iterated_PYTHON_ABIS="${PYTHON_ABIS}"
	else
		if has "${EAPI:-0}" 0 1 2 3; then
			iterated_PYTHON_ABIS="${PYTHON_ABI:-$(PYTHON --ABI)}"
		else
			iterated_PYTHON_ABIS="${PYTHON_ABI}"
		fi
	fi

	# Strip trailing slash from EROOT.
	root="${EROOT%/}"

	while (($#)); do
		case "$1" in
			--allow-evaluated-non-sitedir-paths)
				allow_evaluated_non_sitedir_paths="1"
				;;
			--)
				shift
				break
				;;
			-*)
				die "${FUNCNAME}(): Unrecognized option '$1'"
				;;
			*)
				break
				;;
		esac
		shift
	done

	if [[ "${allow_evaluated_non_sitedir_paths}" == "1" ]] && ! _python_package_supporting_installation_for_multiple_python_abis; then
		die "${FUNCNAME}(): '--allow-evaluated-non-sitedir-paths' option cannot be used in ebuilds of packages not supporting installation for multiple Python ABIs"
	fi

	if [[ "$#" -eq 0 ]]; then
		die "${FUNCNAME}(): Missing files or directories"
	fi

	if ! has "${EAPI:-0}" 0 1 2 || _python_package_supporting_installation_for_multiple_python_abis || _python_implementation || [[ "${CATEGORY}/${PN}" == "sys-apps/portage" ]]; then
		while (($#)); do
			if [[ "$1" =~ ^($|(\.|\.\.|/)($|/)) ]]; then
				die "${FUNCNAME}(): Invalid argument '$1'"
			elif ! _python_implementation && [[ "$1" =~ ^/usr/lib(32|64)?/python[[:digit:]]+\.[[:digit:]]+ ]]; then
				die "${FUNCNAME}(): Paths of directories / files in site-packages directories must be relative to site-packages directories"
			elif [[ "$1" =~ ^/ ]]; then
				if _python_package_supporting_installation_for_multiple_python_abis; then
					if [[ "${allow_evaluated_non_sitedir_paths}" != "1" ]]; then
						die "${FUNCNAME}(): Absolute paths cannot be used in ebuilds of packages supporting installation for multiple Python ABIs"
					fi
					if [[ "$1" != *\$* ]]; then
						die "${FUNCNAME}(): '$1' has invalid syntax"
					fi
					for PYTHON_ABI in ${iterated_PYTHON_ABIS}; do
						eval "search_paths+=(\"\${root}$1\")"
					done
				else
					search_paths+=("${root}$1")
				fi
			else
				for PYTHON_ABI in ${iterated_PYTHON_ABIS}; do
					search_paths+=("${root}$(python_get_sitedir)/$1")
				done
			fi
			shift
		done
	else
		# Deprecated part of python_mod_cleanup()

		search_paths=("${@#/}")
		search_paths=("${search_paths[@]/#/${root}/}")
	fi

	_python_clean_compiled_modules "${search_paths[@]}"
}

# ================================================================================================
# ===================================== DEPRECATED FUNCTIONS =====================================
# ================================================================================================

fi # _PYTHON_ECLASS_INHERITED
