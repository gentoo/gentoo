# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: distutils.eclass
# @MAINTAINER:
# Gentoo Python Project <python@gentoo.org>
# @BLURB: Eclass for packages with build systems using Distutils
# @DESCRIPTION:
# The distutils eclass defines phase functions for packages with build systems using Distutils.
#
# This eclass is DEPRECATED. Please use distutils-r1 instead.

if [[ -z "${_PYTHON_ECLASS_INHERITED}" ]]; then
	inherit python
fi

inherit multilib

case "${EAPI:-0}" in
	6)
		die "${ECLASS}.eclass is banned in EAPI ${EAPI}"
		;;
	0|1)
		EXPORT_FUNCTIONS src_unpack src_compile src_install pkg_postinst pkg_postrm
		;;
	*)
		EXPORT_FUNCTIONS src_prepare src_compile src_install pkg_postinst pkg_postrm
		;;
esac

if [[ -z "$(declare -p PYTHON_DEPEND 2> /dev/null)" ]]; then
	DEPEND="dev-lang/python"
	RDEPEND="${DEPEND}"
fi

	if has "${EAPI:-0}" 0 1 && [[ -n "${SUPPORT_PYTHON_ABIS}" ]]; then
		ewarn
		ewarn "\"${EBUILD}\":"
		ewarn "Deprecation Warning: Usage of distutils.eclass in packages supporting installation"
		ewarn "for multiple Python ABIs in EAPI <=1 is deprecated."
		ewarn "The ebuild should to be fixed. Please report a bug, if it has not been already reported."
		ewarn
	elif has "${EAPI:-0}" 0 1 2 && [[ -z "${SUPPORT_PYTHON_ABIS}" ]]; then
		ewarn
		ewarn "\"${EBUILD}\":"
		ewarn "Deprecation Warning: Usage of distutils.eclass in packages not supporting installation"
		ewarn "for multiple Python ABIs in EAPI <=2 is deprecated."
		ewarn "The ebuild should to be fixed. Please report a bug, if it has not been already reported."
		ewarn
	fi

# 'python' variable is deprecated. Use PYTHON() instead.
if has "${EAPI:-0}" 0 1 2 && [[ -z "${SUPPORT_PYTHON_ABIS}" ]]; then
	python="python"
else
	python="die"
fi

# @ECLASS-VARIABLE: DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES
# @DESCRIPTION:
# Set this to use separate source directories for each enabled version of Python.

# @ECLASS-VARIABLE: DISTUTILS_SETUP_FILES
# @DESCRIPTION:
# Array of paths to setup files.
# Syntax:
#   [current_working_directory|]path_to_setup_file

# @ECLASS-VARIABLE: DISTUTILS_GLOBAL_OPTIONS
# @DESCRIPTION:
# Array of global options passed to setup files.
# Syntax in EAPI <4:
#   global_option
# Syntax in EAPI >=4:
#   Python_ABI_pattern global_option

# @ECLASS-VARIABLE: DISTUTILS_SRC_TEST
# @DESCRIPTION:
# Type of test command used by distutils_src_test().
# IUSE and DEPEND are automatically adjusted, unless DISTUTILS_DISABLE_TEST_DEPENDENCY is set.
# Valid values:
#   setup.py
#   nosetests
#   py.test
#   trial [arguments]

# @ECLASS-VARIABLE: DISTUTILS_DISABLE_TEST_DEPENDENCY
# @DESCRIPTION:
# Disable modification of IUSE and DEPEND caused by setting of DISTUTILS_SRC_TEST.

if [[ -n "${DISTUTILS_SRC_TEST}" && ! "${DISTUTILS_SRC_TEST}" =~ ^(setup\.py|nosetests|py\.test|trial(\ .*)?)$ ]]; then
	die "'DISTUTILS_SRC_TEST' variable has unsupported value '${DISTUTILS_SRC_TEST}'"
fi

if [[ -z "${DISTUTILS_DISABLE_TEST_DEPENDENCY}" ]]; then
	if [[ "${DISTUTILS_SRC_TEST}" == "nosetests" ]]; then
		IUSE="test"
		DEPEND+="${DEPEND:+ }test? ( dev-python/nose )"
	elif [[ "${DISTUTILS_SRC_TEST}" == "py.test" ]]; then
		IUSE="test"
		DEPEND+="${DEPEND:+ }test? ( dev-python/pytest )"
	# trial requires an argument, which is usually equal to "${PN}".
	elif [[ "${DISTUTILS_SRC_TEST}" =~ ^trial(\ .*)?$ ]]; then
		IUSE="test"
		DEPEND+="${DEPEND:+ }test? ( dev-python/twisted-core )"
	fi
fi

if [[ -n "${DISTUTILS_SRC_TEST}" ]]; then
	EXPORT_FUNCTIONS src_test
fi

# Scheduled for deletion on 2011-06-01.
if [[ -n "${DISTUTILS_DISABLE_VERSIONING_OF_PYTHON_SCRIPTS}" ]]; then
	eerror "Use PYTHON_NONVERSIONED_EXECUTABLES=(\".*\") instead of DISTUTILS_DISABLE_VERSIONING_OF_PYTHON_SCRIPTS variable."
	die "DISTUTILS_DISABLE_VERSIONING_OF_PYTHON_SCRIPTS variable is banned"
fi

# @ECLASS-VARIABLE: DOCS
# @DESCRIPTION:
# Additional documentation files installed by distutils_src_install().

_distutils_get_build_dir() {
	if _python_package_supporting_installation_for_multiple_python_abis && [[ -z "${DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES}" ]]; then
		echo "build-${PYTHON_ABI}"
	else
		echo "build"
	fi
}

_distutils_get_PYTHONPATH() {
	if _python_package_supporting_installation_for_multiple_python_abis && [[ -z "${DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES}" ]]; then
		ls -d build-${PYTHON_ABI}/lib* 2> /dev/null
	else
		ls -d build/lib* 2> /dev/null
	fi
}

_distutils_hook() {
	if [[ "$#" -ne 1 ]]; then
		die "${FUNCNAME}() requires 1 argument"
	fi
	if [[ "$(type -t "distutils_src_${EBUILD_PHASE}_$1_hook")" == "function" ]]; then
		"distutils_src_${EBUILD_PHASE}_$1_hook"
	fi
}

_distutils_prepare_global_options() {
	local element option pattern

	if [[ -n "$(declare -p DISTUTILS_GLOBAL_OPTIONS 2> /dev/null)" && "$(declare -p DISTUTILS_GLOBAL_OPTIONS)" != "declare -a DISTUTILS_GLOBAL_OPTIONS="* ]]; then
		die "DISTUTILS_GLOBAL_OPTIONS should be indexed array"
	fi

	if has "${EAPI:-0}" 0 1 2 3; then
		_DISTUTILS_GLOBAL_OPTIONS=("${DISTUTILS_GLOBAL_OPTIONS[@]}")
	else
		_DISTUTILS_GLOBAL_OPTIONS=()

		for element in "${DISTUTILS_GLOBAL_OPTIONS[@]}"; do
			if [[ ! "${element}" =~ ^[^[:space:]]+\ . ]]; then
				die "Element '${element}' of DISTUTILS_GLOBAL_OPTIONS array has invalid syntax"
			fi
			pattern="${element%% *}"
			option="${element#* }"
			if _python_check_python_abi_matching "${PYTHON_ABI}" "${pattern}"; then
				_DISTUTILS_GLOBAL_OPTIONS+=("${option}")
			fi
		done
	fi
}

_distutils_prepare_current_working_directory() {
	if [[ "$1" == *"|"*"|"* ]]; then
		die "Element '$1' of DISTUTILS_SETUP_FILES array has invalid syntax"
	fi

	if [[ "$1" == *"|"* ]]; then
		echo "${_BOLD}[${1%|*}]${_NORMAL}"
		pushd "${1%|*}" > /dev/null || die "Entering directory '${1%|*}' failed"
	fi
}

_distutils_restore_current_working_directory() {
	if [[ "$1" == *"|"* ]]; then
		popd > /dev/null || die "Leaving directory '${1%|*}' failed"
	fi
}

# @FUNCTION: distutils_src_unpack
# @DESCRIPTION:
# The distutils src_unpack function. This function is exported.
distutils_src_unpack() {
	if ! has "${EAPI:-0}" 0 1; then
		die "${FUNCNAME}() cannot be used in this EAPI"
	fi

	if [[ "${EBUILD_PHASE}" != "unpack" ]]; then
		die "${FUNCNAME}() can be used only in src_unpack() phase"
	fi

	unpack ${A}
	cd "${S}"

	distutils_src_prepare
}

# @FUNCTION: distutils_src_prepare
# @DESCRIPTION:
# The distutils src_prepare function. This function is exported.
distutils_src_prepare() {
	if ! has "${EAPI:-0}" 0 1 && [[ "${EBUILD_PHASE}" != "prepare" ]]; then
		die "${FUNCNAME}() can be used only in src_prepare() phase"
	fi

	_python_check_python_pkg_setup_execution

	local distribute_setup_existence="0" ez_setup_existence="0"

	if [[ "$#" -ne 0 ]]; then
		die "${FUNCNAME}() does not accept arguments"
	fi

	# Delete ez_setup files to prevent packages from installing Setuptools on their own.
	[[ -d ez_setup || -f ez_setup.py ]] && ez_setup_existence="1"
	rm -fr ez_setup*
	if [[ "${ez_setup_existence}" == "1" ]]; then
		echo "def use_setuptools(*args, **kwargs): pass" > ez_setup.py
	fi

	# Delete distribute_setup files to prevent packages from installing Distribute on their own.
	[[ -d distribute_setup || -f distribute_setup.py ]] && distribute_setup_existence="1"
	rm -fr distribute_setup*
	if [[ "${distribute_setup_existence}" == "1" ]]; then
		echo "def use_setuptools(*args, **kwargs): pass" > distribute_setup.py
	fi

	if [[ -n "${DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES}" ]]; then
		python_copy_sources
	fi
}

# @FUNCTION: distutils_src_compile
# @DESCRIPTION:
# The distutils src_compile function. This function is exported.
# In ebuilds of packages supporting installation for multiple versions of Python, this function
# calls distutils_src_compile_pre_hook() and distutils_src_compile_post_hook(), if they are defined.
distutils_src_compile() {
	if [[ "${EBUILD_PHASE}" != "compile" ]]; then
		die "${FUNCNAME}() can be used only in src_compile() phase"
	fi

	_python_check_python_pkg_setup_execution
	_python_set_color_variables

	local setup_file

	if _python_package_supporting_installation_for_multiple_python_abis; then
		distutils_building() {
			_distutils_hook pre

			_distutils_prepare_global_options

			for setup_file in "${DISTUTILS_SETUP_FILES[@]-setup.py}"; do
				_distutils_prepare_current_working_directory "${setup_file}"

				echo ${_BOLD}"$(PYTHON)" "${setup_file#*|}" "${_DISTUTILS_GLOBAL_OPTIONS[@]}" build -b "$(_distutils_get_build_dir)" "$@"${_NORMAL}
				"$(PYTHON)" "${setup_file#*|}" "${_DISTUTILS_GLOBAL_OPTIONS[@]}" build -b "$(_distutils_get_build_dir)" "$@" || return "$?"

				_distutils_restore_current_working_directory "${setup_file}"
			done

			_distutils_hook post
		}
		python_execute_function ${DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES:+-s} distutils_building "$@"
		unset -f distutils_building
	else
		_distutils_prepare_global_options

		for setup_file in "${DISTUTILS_SETUP_FILES[@]-setup.py}"; do
			_distutils_prepare_current_working_directory "${setup_file}"

			echo ${_BOLD}"$(PYTHON)" "${setup_file#*|}" "${_DISTUTILS_GLOBAL_OPTIONS[@]}" build "$@"${_NORMAL}
			"$(PYTHON)" "${setup_file#*|}" "${_DISTUTILS_GLOBAL_OPTIONS[@]}" build "$@" || die "Building failed"

			_distutils_restore_current_working_directory "${setup_file}"
		done
	fi
}

_distutils_src_test_hook() {
	if [[ "$#" -ne 1 ]]; then
		die "${FUNCNAME}() requires 1 arguments"
	fi

	if ! _python_package_supporting_installation_for_multiple_python_abis; then
		return
	fi

	if [[ "$(type -t "distutils_src_test_pre_hook")" == "function" ]]; then
		eval "python_execute_$1_pre_hook() {
			distutils_src_test_pre_hook
		}"
	fi

	if [[ "$(type -t "distutils_src_test_post_hook")" == "function" ]]; then
		eval "python_execute_$1_post_hook() {
			distutils_src_test_post_hook
		}"
	fi
}

# @FUNCTION: distutils_src_test
# @DESCRIPTION:
# The distutils src_test function. This function is exported, when DISTUTILS_SRC_TEST variable is set.
# In ebuilds of packages supporting installation for multiple versions of Python, this function
# calls distutils_src_test_pre_hook() and distutils_src_test_post_hook(), if they are defined.
distutils_src_test() {
	if [[ "${EBUILD_PHASE}" != "test" ]]; then
		die "${FUNCNAME}() can be used only in src_test() phase"
	fi

	_python_check_python_pkg_setup_execution
	_python_set_color_variables

	local arguments setup_file

	if [[ "${DISTUTILS_SRC_TEST}" == "setup.py" ]]; then
		if _python_package_supporting_installation_for_multiple_python_abis; then
			distutils_testing() {
				_distutils_hook pre

				_distutils_prepare_global_options

				for setup_file in "${DISTUTILS_SETUP_FILES[@]-setup.py}"; do
					_distutils_prepare_current_working_directory "${setup_file}"

					echo ${_BOLD}PYTHONPATH="$(_distutils_get_PYTHONPATH)" "$(PYTHON)" "${setup_file#*|}" "${_DISTUTILS_GLOBAL_OPTIONS[@]}" $([[ -z "${DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES}" ]] && echo build -b "$(_distutils_get_build_dir)") test "$@"${_NORMAL}
					PYTHONPATH="$(_distutils_get_PYTHONPATH)" "$(PYTHON)" "${setup_file#*|}" "${_DISTUTILS_GLOBAL_OPTIONS[@]}" $([[ -z "${DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES}" ]] && echo build -b "$(_distutils_get_build_dir)") test "$@" || return "$?"

					_distutils_restore_current_working_directory "${setup_file}"
				done

				_distutils_hook post
			}
			python_execute_function ${DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES:+-s} distutils_testing "$@"
			unset -f distutils_testing
		else
			_distutils_prepare_global_options

			for setup_file in "${DISTUTILS_SETUP_FILES[@]-setup.py}"; do
				_distutils_prepare_current_working_directory "${setup_file}"

				echo ${_BOLD}PYTHONPATH="$(_distutils_get_PYTHONPATH)" "$(PYTHON)" "${setup_file#*|}" "${_DISTUTILS_GLOBAL_OPTIONS[@]}" test "$@"${_NORMAL}
				PYTHONPATH="$(_distutils_get_PYTHONPATH)" "$(PYTHON)" "${setup_file#*|}" "${_DISTUTILS_GLOBAL_OPTIONS[@]}" test "$@" || die "Testing failed"

				_distutils_restore_current_working_directory "${setup_file}"
			done
		fi
	elif [[ "${DISTUTILS_SRC_TEST}" == "nosetests" ]]; then
		_distutils_src_test_hook nosetests

		python_execute_nosetests -P '$(_distutils_get_PYTHONPATH)' ${DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES:+-s} -- "$@"
	elif [[ "${DISTUTILS_SRC_TEST}" == "py.test" ]]; then
		_distutils_src_test_hook py.test

		python_execute_py.test -P '$(_distutils_get_PYTHONPATH)' ${DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES:+-s} -- "$@"
	# trial requires an argument, which is usually equal to "${PN}".
	elif [[ "${DISTUTILS_SRC_TEST}" =~ ^trial(\ .*)?$ ]]; then
		if [[ "${DISTUTILS_SRC_TEST}" == "trial "* ]]; then
			arguments="${DISTUTILS_SRC_TEST#trial }"
		else
			arguments="${PN}"
		fi

		_distutils_src_test_hook trial

		python_execute_trial -P '$(_distutils_get_PYTHONPATH)' ${DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES:+-s} -- ${arguments} "$@"
	else
		die "'DISTUTILS_SRC_TEST' variable has unsupported value '${DISTUTILS_SRC_TEST}'"
	fi
}

# @FUNCTION: distutils_src_install
# @DESCRIPTION:
# The distutils src_install function. This function is exported.
# In ebuilds of packages supporting installation for multiple versions of Python, this function
# calls distutils_src_install_pre_hook() and distutils_src_install_post_hook(), if they are defined.
# It also installs some standard documentation files (AUTHORS, Change*, CHANGELOG, CONTRIBUTORS,
# KNOWN_BUGS, MAINTAINERS, NEWS, README*, TODO).
distutils_src_install() {
	if [[ "${EBUILD_PHASE}" != "install" ]]; then
		die "${FUNCNAME}() can be used only in src_install() phase"
	fi

	_python_check_python_pkg_setup_execution
	_python_initialize_prefix_variables
	_python_set_color_variables

	local default_docs doc line nspkg_pth_file nspkg_pth_files=() setup_file

	if _python_package_supporting_installation_for_multiple_python_abis; then
		distutils_installation() {
			_distutils_hook pre

			_distutils_prepare_global_options

			for setup_file in "${DISTUTILS_SETUP_FILES[@]-setup.py}"; do
				_distutils_prepare_current_working_directory "${setup_file}"

				echo ${_BOLD}"$(PYTHON)" "${setup_file#*|}" "${_DISTUTILS_GLOBAL_OPTIONS[@]}" $([[ -z "${DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES}" ]] && echo build -b "$(_distutils_get_build_dir)") install --no-compile --root="${T}/images/${PYTHON_ABI}" "$@"${_NORMAL}
				"$(PYTHON)" "${setup_file#*|}" "${_DISTUTILS_GLOBAL_OPTIONS[@]}" $([[ -z "${DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES}" ]] && echo build -b "$(_distutils_get_build_dir)") install --no-compile --root="${T}/images/${PYTHON_ABI}" "$@" || return "$?"

				_distutils_restore_current_working_directory "${setup_file}"
			done

			_distutils_hook post
		}
		python_execute_function ${DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES:+-s} distutils_installation "$@"
		unset -f distutils_installation

		python_merge_intermediate_installation_images "${T}/images"
	else
		# Mark the package to be rebuilt after a Python upgrade.
		python_need_rebuild

		_distutils_prepare_global_options

		for setup_file in "${DISTUTILS_SETUP_FILES[@]-setup.py}"; do
			_distutils_prepare_current_working_directory "${setup_file}"

			echo ${_BOLD}"$(PYTHON)" "${setup_file#*|}" "${_DISTUTILS_GLOBAL_OPTIONS[@]}" install --root="${D}" --no-compile "$@"${_NORMAL}
			"$(PYTHON)" "${setup_file#*|}" "${_DISTUTILS_GLOBAL_OPTIONS[@]}" install --root="${D}" --no-compile "$@" || die "Installation failed"

			_distutils_restore_current_working_directory "${setup_file}"
		done
	fi

	while read -d $'\0' -r nspkg_pth_file; do
		nspkg_pth_files+=("${nspkg_pth_file}")
	done < <(find "${ED}" -name "*-nspkg.pth" -type f -print0)

	if [[ "${#nspkg_pth_files[@]}" -gt 0 ]]; then
		einfo
		einfo "Python namespaces:"
		for nspkg_pth_file in "${nspkg_pth_files[@]}"; do
			einfo "    '${nspkg_pth_file#${ED%/}}':"
			while read -r line; do
				einfo "        $(echo "${line}" | sed -e "s/.*types\.ModuleType('\([^']\+\)').*/\1/")"
			done < "${nspkg_pth_file}"
			#if ! has "${EAPI:-0}" 0 1 2 3; then
			#	rm -f "${nspkg_pth_file}" || die "Deletion of '${nspkg_pth_file}' failed"
			#fi
		done
		einfo
	fi

	if [[ -e "${ED}usr/local" ]]; then
		die "Illegal installation into /usr/local"
	fi

	default_docs="AUTHORS Change* CHANGELOG CONTRIBUTORS KNOWN_BUGS MAINTAINERS NEWS README* TODO"

	for doc in ${default_docs}; do
		[[ -s "${doc}" ]] && dodoc "${doc}"
	done

	if has "${EAPI:-0}" 0 1 2 3; then
		if [[ -n "${DOCS}" ]]; then
			dodoc ${DOCS} || die "dodoc failed"
		fi
	else
		if [[ -n "${DOCS}" ]]; then
			dodoc -r ${DOCS} || die "dodoc failed"
		fi
	fi

	DISTUTILS_SRC_INSTALL_EXECUTED="1"
}

# @FUNCTION: distutils_pkg_postinst
# @DESCRIPTION:
# The distutils pkg_postinst function. This function is exported.
# When PYTHON_MODNAME variable is set, then this function calls python_mod_optimize() with modules
# specified in PYTHON_MODNAME variable. Otherwise it calls python_mod_optimize() with module, whose
# name is equal to name of current package, if this module exists.
distutils_pkg_postinst() {
	if [[ "${EBUILD_PHASE}" != "postinst" ]]; then
		die "${FUNCNAME}() can be used only in pkg_postinst() phase"
	fi

	_python_check_python_pkg_setup_execution
	_python_initialize_prefix_variables

	if [[ -z "${DISTUTILS_SRC_INSTALL_EXECUTED}" ]]; then
		die "${FUNCNAME}() called illegally"
	fi

	local pylibdir pymod

	if [[ "$#" -ne 0 ]]; then
		die "${FUNCNAME}() does not accept arguments"
	fi

	if [[ -z "$(declare -p PYTHON_MODNAME 2> /dev/null)" ]]; then
		for pylibdir in "${EROOT}"usr/$(get_libdir)/python* "${EROOT}"usr/share/jython-*/Lib; do
			if [[ -d "${pylibdir}/site-packages/${PN}" ]]; then
				PYTHON_MODNAME="${PN}"
			fi
		done
	fi

	if [[ -n "${PYTHON_MODNAME}" ]]; then
		if ! has "${EAPI:-0}" 0 1 2 || _python_package_supporting_installation_for_multiple_python_abis; then
			python_mod_optimize ${PYTHON_MODNAME}
		else
			for pymod in ${PYTHON_MODNAME}; do
				python_mod_optimize "$(python_get_sitedir)/${pymod}"
			done
		fi
	fi
}

# @FUNCTION: distutils_pkg_postrm
# @DESCRIPTION:
# The distutils pkg_postrm function. This function is exported.
# When PYTHON_MODNAME variable is set, then this function calls python_mod_cleanup() with modules
# specified in PYTHON_MODNAME variable. Otherwise it calls python_mod_cleanup() with module, whose
# name is equal to name of current package, if this module exists.
distutils_pkg_postrm() {
	if [[ "${EBUILD_PHASE}" != "postrm" ]]; then
		die "${FUNCNAME}() can be used only in pkg_postrm() phase"
	fi

	_python_check_python_pkg_setup_execution
	_python_initialize_prefix_variables

	if [[ -z "${DISTUTILS_SRC_INSTALL_EXECUTED}" ]]; then
		die "${FUNCNAME}() called illegally"
	fi

	local pylibdir pymod

	if [[ "$#" -ne 0 ]]; then
		die "${FUNCNAME}() does not accept arguments"
	fi

	if [[ -z "$(declare -p PYTHON_MODNAME 2> /dev/null)" ]]; then
		for pylibdir in "${EROOT}"usr/$(get_libdir)/python* "${EROOT}"usr/share/jython-*/Lib; do
			if [[ -d "${pylibdir}/site-packages/${PN}" ]]; then
				PYTHON_MODNAME="${PN}"
			fi
		done
	fi

	if [[ -n "${PYTHON_MODNAME}" ]]; then
		if ! has "${EAPI:-0}" 0 1 2 || _python_package_supporting_installation_for_multiple_python_abis; then
			python_mod_cleanup ${PYTHON_MODNAME}
		else
			for pymod in ${PYTHON_MODNAME}; do
				for pylibdir in "${EROOT}"usr/$(get_libdir)/python*; do
					if [[ -d "${pylibdir}/site-packages/${pymod}" ]]; then
						python_mod_cleanup "${pylibdir#${EROOT%/}}/site-packages/${pymod}"
					fi
				done
			done
		fi
	fi
}

# @FUNCTION: distutils_get_intermediate_installation_image
# @DESCRIPTION:
# Print path to intermediate installation image.
#
# This function can be used only in distutils_src_install_pre_hook() and distutils_src_install_post_hook().
distutils_get_intermediate_installation_image() {
	if [[ "${EBUILD_PHASE}" != "install" ]]; then
		die "${FUNCNAME}() can be used only in src_install() phase"
	fi

	if ! _python_package_supporting_installation_for_multiple_python_abis; then
		die "${FUNCNAME}() cannot be used in ebuilds of packages not supporting installation for multiple Python ABIs"
	fi

	_python_check_python_pkg_setup_execution

	if [[ ! "${FUNCNAME[1]}" =~ ^distutils_src_install_(pre|post)_hook$ ]]; then
		die "${FUNCNAME}() can be used only in distutils_src_install_pre_hook() and distutils_src_install_post_hook()"
	fi

	if [[ "$#" -ne 0 ]]; then
		die "${FUNCNAME}() does not accept arguments"
	fi

	echo "${T}/images/${PYTHON_ABI}"
}
