# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: distutils-r1.eclass
# @MAINTAINER:
# Python team <python@gentoo.org>
# @AUTHOR:
# Author: Michał Górny <mgorny@gentoo.org>
# Based on the work of: Krzysztof Pawlik <nelchael@gentoo.org>
# @SUPPORTED_EAPIS: 5 6 7
# @BLURB: A simple eclass to build Python packages using distutils.
# @DESCRIPTION:
# A simple eclass providing functions to build Python packages using
# the distutils build system. It exports phase functions for all
# the src_* phases. Each of the phases runs two pseudo-phases:
# python_..._all() (e.g. python_prepare_all()) once in ${S}, then
# python_...() (e.g. python_prepare()) for each implementation
# (see: python_foreach_impl() in python-r1).
#
# In distutils-r1_src_prepare(), the 'all' function is run before
# per-implementation ones (because it creates the implementations),
# per-implementation functions are run in a random order.
#
# In remaining phase functions, the per-implementation functions are run
# before the 'all' one, and they are ordered from the least to the most
# preferred implementation (so that 'better' files overwrite 'worse'
# ones).
#
# If the ebuild doesn't specify a particular pseudo-phase function,
# the default one will be used (distutils-r1_...). Defaults are provided
# for all per-implementation pseudo-phases, python_prepare_all()
# and python_install_all(); whenever writing your own pseudo-phase
# functions, you should consider calling the defaults (and especially
# distutils-r1_python_prepare_all).
#
# Please note that distutils-r1 sets RDEPEND and DEPEND unconditionally
# for you.
#
# Also, please note that distutils-r1 will always inherit python-r1
# as well. Thus, all the variables defined and documented there are
# relevant to the packages using distutils-r1.
#
# For more information, please see the Python Guide:
# https://dev.gentoo.org/~mgorny/python-guide/

case "${EAPI:-0}" in
	0|1|2|3|4)
		die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}"
		;;
	5|6|7)
		;;
	*)
		die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
		;;
esac

# @ECLASS-VARIABLE: DISTUTILS_OPTIONAL
# @DEFAULT_UNSET
# @DESCRIPTION:
# If set to a non-null value, distutils part in the ebuild will
# be considered optional. No dependencies will be added and no phase
# functions will be exported.
#
# If you enable DISTUTILS_OPTIONAL, you have to set proper dependencies
# for your package (using ${PYTHON_DEPS}) and to either call
# distutils-r1 default phase functions or call the build system
# manually.

# @ECLASS-VARIABLE: DISTUTILS_SINGLE_IMPL
# @DEFAULT_UNSET
# @DESCRIPTION:
# If set to a non-null value, the ebuild will support setting a single
# Python implementation only. It will effectively replace the python-r1
# eclass inherit with python-single-r1.
#
# Note that inheriting python-single-r1 will cause pkg_setup()
# to be exported. It must be run in order for the eclass functions
# to function properly.

# @ECLASS-VARIABLE: DISTUTILS_USE_SETUPTOOLS
# @PRE_INHERIT
# @DESCRIPTION:
# Controls adding dev-python/setuptools dependency.  The allowed values
# are:
#
# - no -- do not add the dependency (pure distutils package)
# - bdepend -- add it to BDEPEND (the default)
# - rdepend -- add it to BDEPEND+RDEPEND (when using entry_points)
# - pyproject.toml -- use pyproject2setuptools to install a project
#                     using pyproject.toml (flit, poetry...)
# - manual -- do not add the depedency and suppress the checks
#             (assumes you will take care of doing it correctly)
#
# This variable is effective only if DISTUTILS_OPTIONAL is disabled.
# It needs to be set before the inherit line.
: ${DISTUTILS_USE_SETUPTOOLS:=bdepend}

if [[ ! ${_DISTUTILS_R1} ]]; then

[[ ${EAPI} == [456] ]] && inherit eutils
[[ ${EAPI} == [56] ]] && inherit xdg-utils
inherit multiprocessing toolchain-funcs

if [[ ! ${DISTUTILS_SINGLE_IMPL} ]]; then
	inherit python-r1
else
	inherit python-single-r1
fi

fi

if [[ ! ${DISTUTILS_OPTIONAL} ]]; then
	EXPORT_FUNCTIONS src_prepare src_configure src_compile src_test src_install
fi

if [[ ! ${_DISTUTILS_R1} ]]; then

_distutils_set_globals() {
	local rdep=${PYTHON_DEPS}
	local bdep=${rdep}

	if [[ ! ${DISTUTILS_SINGLE_IMPL} ]]; then
		local sdep=">=dev-python/setuptools-42.0.2[${PYTHON_USEDEP}]"
	else
		local sdep="$(python_gen_cond_dep '
			>=dev-python/setuptools-42.0.2[${PYTHON_MULTI_USEDEP}]
		')"
	fi

	case ${DISTUTILS_USE_SETUPTOOLS} in
		no|manual)
			;;
		bdepend)
			bdep+=" ${sdep}"
			;;
		rdepend)
			bdep+=" ${sdep}"
			rdep+=" ${sdep}"
			;;
		pyproject.toml)
			bdep+=" dev-python/pyproject2setuppy[${PYTHON_USEDEP}]"
			;;
		*)
			die "Invalid DISTUTILS_USE_SETUPTOOLS=${DISTUTILS_USE_SETUPTOOLS}"
			;;
	esac

	RDEPEND=${rdep}
	if [[ ${EAPI} != [56] ]]; then
		BDEPEND=${bdep}
	else
		DEPEND=${bdep}
	fi
	REQUIRED_USE=${PYTHON_REQUIRED_USE}
}
[[ ! ${DISTUTILS_OPTIONAL} ]] && _distutils_set_globals
unset -f _distutils_set_globals

# @ECLASS-VARIABLE: PATCHES
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array containing patches to be applied to the sources before
# copying them.
#
# If unset, no custom patches will be applied.
#
# Please note, however, that at some point the eclass may apply
# additional distutils patches/quirks independently of this variable.
#
# Example:
# @CODE
# PATCHES=( "${FILESDIR}"/${P}-make-gentoo-happy.patch )
# @CODE

# @ECLASS-VARIABLE: DOCS
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array containing documents installed using dodoc. The files listed
# there must exist in the directory from which
# distutils-r1_python_install_all() is run (${S} by default).
#
# If unset, the function will instead look up files matching default
# filename pattern list (from the Package Manager Specification),
# and install those found.
#
# Example:
# @CODE
# DOCS=( NEWS README )
# @CODE

# @ECLASS-VARIABLE: HTML_DOCS
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array containing documents installed using dohtml. The files
# and directories listed there must exist in the directory from which
# distutils-r1_python_install_all() is run (${S} by default).
#
# If unset, no HTML docs will be installed.
#
# Example:
# @CODE
# HTML_DOCS=( doc/html/. )
# @CODE

# @ECLASS-VARIABLE: EXAMPLES
# @DEFAULT_UNSET
# @DESCRIPTION:
# OBSOLETE: this variable is deprecated and banned in EAPI 6
#
# An array containing examples installed into 'examples' doc
# subdirectory. The files and directories listed there must exist
# in the directory from which distutils-r1_python_install_all() is run
# (${S} by default).
#
# The 'examples' subdirectory will be marked not to be compressed
# automatically.
#
# If unset, no examples will be installed.
#
# Example:
# @CODE
# EXAMPLES=( examples/. demos/. )
# @CODE

# @ECLASS-VARIABLE: DISTUTILS_IN_SOURCE_BUILD
# @DEFAULT_UNSET
# @DESCRIPTION:
# If set to a non-null value, in-source builds will be enabled.
# If unset, the default is to use in-source builds when python_prepare()
# is declared, and out-of-source builds otherwise.
#
# If in-source builds are used, the eclass will create a copy of package
# sources for each Python implementation in python_prepare_all(),
# and work on that copy afterwards.
#
# If out-of-source builds are used, the eclass will instead work
# on the sources directly, prepending setup.py arguments with
# 'build --build-base ${BUILD_DIR}' to enforce keeping & using built
# files in the specific root.

# @ECLASS-VARIABLE: DISTUTILS_ALL_SUBPHASE_IMPLS
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array of patterns specifying which implementations can be used
# for *_all() sub-phase functions. If undefined, defaults to '*'
# (allowing any implementation). If multiple values are specified,
# implementations matching any of the patterns will be accepted.
#
# The patterns can be either fnmatch-style patterns (matched via bash
# == operator against PYTHON_COMPAT values) or '-2' / '-3' to indicate
# appropriately all enabled Python 2/3 implementations (alike
# python_is_python3). Remember to escape or quote the fnmatch patterns
# to prevent accidental shell filename expansion.
#
# If the restriction needs to apply conditionally to a USE flag,
# the variable should be set conditionally as well (e.g. in an early
# phase function or other convenient location).
#
# Please remember to add a matching || block to REQUIRED_USE,
# to ensure that at least one implementation matching the patterns will
# be enabled.
#
# Example:
# @CODE
# REQUIRED_USE="doc? ( || ( $(python_gen_useflags 'python2*') ) )"
#
# pkg_setup() {
#     use doc && DISTUTILS_ALL_SUBPHASE_IMPLS=( 'python2*' )
# }
# @CODE

# @ECLASS-VARIABLE: mydistutilsargs
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array containing options to be passed to setup.py.
#
# Example:
# @CODE
# python_configure_all() {
# 	mydistutilsargs=( --enable-my-hidden-option )
# }
# @CODE

# @FUNCTION: distutils_enable_sphinx
# @USAGE: <subdir> [--no-autodoc | <plugin-pkgs>...]
# @DESCRIPTION:
# Set up IUSE, BDEPEND, python_check_deps() and python_compile_all() for
# building HTML docs via dev-python/sphinx.  python_compile_all() will
# append to HTML_DOCS if docs are enabled.
#
# This helper is meant for the most common case, that is a single Sphinx
# subdirectory with standard layout, building and installing HTML docs
# behind USE=doc.  It assumes it's the only consumer of the three
# aforementioned functions.  If you need to use a custom implemention,
# you can't use it.
#
# If your package uses additional Sphinx plugins, they should be passed
# (without PYTHON_USEDEP) as <plugin-pkgs>.  The function will take care
# of setting appropriate any-of dep and python_check_deps().
#
# If no plugin packages are specified, the eclass will still utilize
# any-r1 API to support autodoc (documenting source code).
# If the package uses neither autodoc nor additional plugins, you should
# pass --no-autodoc to disable this API and simplify the resulting code.
#
# This function must be called in global scope.  Take care not to
# overwrite the variables set by it.  If you need to extend
# python_compile_all(), you can call the original implementation
# as sphinx_compile_all.
distutils_enable_sphinx() {
	debug-print-function ${FUNCNAME} "${@}"
	[[ ${#} -ge 1 ]] || die "${FUNCNAME} takes at least one arg: <subdir>"

	_DISTUTILS_SPHINX_SUBDIR=${1}
	shift
	_DISTUTILS_SPHINX_PLUGINS=( "${@}" )

	local deps autodoc=1 d
	for d; do
		if [[ ${d} == --no-autodoc ]]; then
			autodoc=
		else
			deps+="
				${d}[\${PYTHON_USEDEP}]"
		fi
	done

	if [[ ! ${autodoc} && -n ${deps} ]]; then
		die "${FUNCNAME}: do not pass --no-autodoc if external plugins are used"
	fi
	if [[ ${autodoc} ]]; then
		deps="$(python_gen_any_dep "
			dev-python/sphinx[\${PYTHON_USEDEP}]
			${deps}")"

		python_check_deps() {
			use doc || return 0
			local p
			for p in dev-python/sphinx "${_DISTUTILS_SPHINX_PLUGINS[@]}"; do
				has_version "${p}[${PYTHON_USEDEP}]" || return 1
			done
		}
	else
		deps="dev-python/sphinx"
	fi

	sphinx_compile_all() {
		use doc || return

		local confpy=${_DISTUTILS_SPHINX_SUBDIR}/conf.py
		[[ -f ${confpy} ]] ||
			die "${confpy} not found, distutils_enable_sphinx call wrong"

		if [[ ${_DISTUTILS_SPHINX_PLUGINS[0]} == --no-autodoc ]]; then
			if grep -F -q 'sphinx.ext.autodoc' "${confpy}"; then
				die "distutils_enable_sphinx: --no-autodoc passed but sphinx.ext.autodoc found in ${confpy}"
			fi
		elif [[ -z ${_DISTUTILS_SPHINX_PLUGINS[@]} ]]; then
			if ! grep -F -q 'sphinx.ext.autodoc' "${confpy}"; then
				die "distutils_enable_sphinx: sphinx.ext.autodoc not found in ${confpy}, pass --no-autodoc"
			fi
		fi

		build_sphinx "${_DISTUTILS_SPHINX_SUBDIR}"
	}
	python_compile_all() { sphinx_compile_all; }

	IUSE+=" doc"
	if [[ ${EAPI} == [56] ]]; then
		DEPEND+=" doc? ( ${deps} )"
	else
		BDEPEND+=" doc? ( ${deps} )"
	fi

	# we need to ensure successful return in case we're called last,
	# otherwise Portage may wrongly assume sourcing failed
	return 0
}

# @FUNCTION: distutils_enable_tests
# @USAGE: <test-runner>
# @DESCRIPTION:
# Set up IUSE, RESTRICT, BDEPEND and python_test() for running tests
# with the specified test runner.  Also copies the current value
# of RDEPEND to test?-BDEPEND.  The test-runner argument must be one of:
#
# - nose: nosetests (dev-python/nose)
# - pytest: dev-python/pytest
# - setup.py: setup.py test (no deps included)
# - unittest: for built-in Python unittest module
#
# This function is meant as a helper for common use cases, and it only
# takes care of basic setup.  You still need to list additional test
# dependencies manually.  If you have uncommon use case, you should
# not use it and instead enable tests manually.
#
# This function must be called in global scope, after RDEPEND has been
# declared.  Take care not to overwrite the variables set by it.
distutils_enable_tests() {
	debug-print-function ${FUNCNAME} "${@}"
	[[ ${#} -eq 1 ]] || die "${FUNCNAME} takes exactly one argument: test-runner"

	local test_pkg
	case ${1} in
		nose)
			test_pkg="dev-python/nose"
			python_test() {
				nosetests -v || die "Tests fail with ${EPYTHON}"
			}
			;;
		pytest)
			test_pkg="dev-python/pytest"
			python_test() {
				pytest -vv || die "Tests fail with ${EPYTHON}"
			}
			;;
		setup.py)
			python_test() {
				nonfatal esetup.py test --verbose ||
					die "Tests fail with ${EPYTHON}"
			}
			;;
		unittest)
			python_test() {
				"${EPYTHON}" -m unittest discover -v ||
					die "Tests fail with ${EPYTHON}"
			}
			;;
		*)
			die "${FUNCNAME}: unsupported argument: ${1}"
	esac

	local test_deps=${RDEPEND}
	if [[ -n ${test_pkg} ]]; then
		if [[ ! ${DISTUTILS_SINGLE_IMPL} ]]; then
			test_deps+=" ${test_pkg}[${PYTHON_USEDEP}]"
		else
			test_deps+=" $(python_gen_cond_dep "
				${test_pkg}[\${PYTHON_MULTI_USEDEP}]
			")"
		fi
	fi
	if [[ -n ${test_deps} ]]; then
		IUSE+=" test"
		RESTRICT+=" !test? ( test )"
		if [[ ${EAPI} == [56] ]]; then
			DEPEND+=" test? ( ${test_deps} )"
		else
			BDEPEND+=" test? ( ${test_deps} )"
		fi
	fi

	# we need to ensure successful return in case we're called last,
	# otherwise Portage may wrongly assume sourcing failed
	return 0
}

# @FUNCTION: _distutils-r1_verify_use_setuptools
# @INTERNAL
# @DESCRIPTION:
# Check setup.py for signs that DISTUTILS_USE_SETUPTOOLS have been set
# incorrectly.
_distutils_verify_use_setuptools() {
	[[ ${DISTUTILS_OPTIONAL} ]] && return
	[[ ${DISTUTILS_USE_SETUPTOOLS} == manual ]] && return
	[[ ${DISTUTILS_USE_SETUPTOOLS} == pyproject.toml ]] && return

	# ok, those are cheap greps.  we can try toimprove them if we hit
	# false positives.
	local expected=no
	if [[ ${CATEGORY}/${PN} == dev-python/setuptools ]]; then
		# as a special case, setuptools provides itself ;-)
		:
	elif grep -E -q -s '(from|import)\s+setuptools' setup.py; then
		if grep -E -q -s 'entry_points\s*=' setup.py; then
			expected=rdepend
		elif grep -F -q -s '[options.entry_points]' setup.cfg; then
			expected=rdepend
		else
			expected=bdepend
		fi
	fi

	if [[ ${DISTUTILS_USE_SETUPTOOLS} != ${expected} ]]; then
		if [[ ! ${_DISTUTILS_SETUPTOOLS_WARNED} ]]; then
			_DISTUTILS_SETUPTOOLS_WARNED=1
			local def=
			[[ ${DISTUTILS_USE_SETUPTOOLS} == bdepend ]] && def=' (default?)'

			eqawarn "DISTUTILS_USE_SETUPTOOLS value is probably incorrect"
			eqawarn "  value:    DISTUTILS_USE_SETUPTOOLS=${DISTUTILS_USE_SETUPTOOLS}${def}"
			eqawarn "  expected: DISTUTILS_USE_SETUPTOOLS=${expected}"
		fi
	fi
}

# @FUNCTION: esetup.py
# @USAGE: [<args>...]
# @DESCRIPTION:
# Run setup.py using currently selected Python interpreter
# (if ${EPYTHON} is set; fallback 'python' otherwise).
#
# setup.py will be passed the following, in order:
# 1. ${mydistutilsargs[@]}
# 2. additional arguments passed to the esetup.py function.
#
# Please note that setup.py will respect defaults (unless overridden
# via command-line options) from setup.cfg that is created
# in distutils-r1_python_compile and in distutils-r1_python_install.
#
# This command dies on failure.
esetup.py() {
	debug-print-function ${FUNCNAME} "${@}"

	local die_args=()
	[[ ${EAPI} != [45] ]] && die_args+=( -n )

	[[ ${BUILD_DIR} ]] && _distutils-r1_create_setup_cfg
	_distutils_verify_use_setuptools

	set -- "${EPYTHON:-python}" setup.py "${mydistutilsargs[@]}" "${@}"

	echo "${@}" >&2
	"${@}" || die "${die_args[@]}"
	local ret=${?}

	if [[ ${BUILD_DIR} ]]; then
		rm "${HOME}"/.pydistutils.cfg || die "${die_args[@]}"
	fi

	return ${ret}
}

# @FUNCTION: distutils_install_for_testing
# @USAGE: [<args>...]
# @DESCRIPTION:
# Install the package into a temporary location for running tests.
# Update PYTHONPATH appropriately and set TEST_DIR to the test
# installation root. The Python packages will be installed in 'lib'
# subdir, and scripts in 'scripts' subdir (like in BUILD_DIR).
#
# Please note that this function should be only used if package uses
# namespaces (and therefore proper install needs to be done to enforce
# PYTHONPATH) or tests rely on the results of install command.
# For most of the packages, tests built in BUILD_DIR are good enough.
distutils_install_for_testing() {
	debug-print-function ${FUNCNAME} "${@}"

	# A few notes:
	# 1) because of namespaces, we can't use 'install --root',
	# 2) 'install --home' is terribly broken on pypy, so we need
	#    to override --install-lib and --install-scripts,
	# 3) non-root 'install' complains about PYTHONPATH and missing dirs,
	#    so we need to set it properly and mkdir them,
	# 4) it runs a bunch of commands which write random files to cwd,
	#    in order to avoid that, we add the necessary path overrides
	#    in _distutils-r1_create_setup_cfg.

	TEST_DIR=${BUILD_DIR}/test
	local bindir=${TEST_DIR}/scripts
	local libdir=${TEST_DIR}/lib
	PYTHONPATH=${libdir}:${PYTHONPATH}

	local add_args=(
		install
			--home="${TEST_DIR}"
			--install-lib="${libdir}"
			--install-scripts="${bindir}"
	)

	mkdir -p "${libdir}" || die
	esetup.py "${add_args[@]}" "${@}"
}

# @FUNCTION: _distutils-r1_disable_ez_setup
# @INTERNAL
# @DESCRIPTION:
# Stub out ez_setup.py and distribute_setup.py to prevent packages
# from trying to download a local copy of setuptools.
_distutils-r1_disable_ez_setup() {
	local stub="def use_setuptools(*args, **kwargs): pass"
	if [[ -f ez_setup.py ]]; then
		echo "${stub}" > ez_setup.py || die
	fi
	if [[ -f distribute_setup.py ]]; then
		echo "${stub}" > distribute_setup.py || die
	fi
}

# @FUNCTION: _distutils-r1_handle_pyproject_toml
# @INTERNAL
# @DESCRIPTION:
# Generate setup.py for pyproject.toml if requested.
_distutils-r1_handle_pyproject_toml() {
	if [[ ! -f setup.py && -f pyproject.toml ]]; then
		if [[ ${DISTUTILS_USE_SETUPTOOLS} == pyproject.toml ]]; then
			cat > setup.py <<-EOF || die
				#!/usr/bin/env python
				from pyproject2setuppy.main import main
				main()
			EOF
			chmod +x setup.py || die
		else
			eerror "No setup.py found but pyproject.toml is present.  In order to enable"
			eerror "pyproject.toml support in distutils-r1, set:"
			eerror "  DISTUTILS_USE_SETUPTOOLS=pyproject.toml"
			die "No setup.py found and DISTUTILS_USE_SETUPTOOLS!=pyproject.toml"
		fi
	fi
}

# @FUNCTION: distutils-r1_python_prepare_all
# @DESCRIPTION:
# The default python_prepare_all(). It applies the patches from PATCHES
# array, then user patches and finally calls python_copy_sources to
# create copies of resulting sources for each Python implementation.
#
# At some point in the future, it may also apply eclass-specific
# distutils patches and/or quirks.
distutils-r1_python_prepare_all() {
	debug-print-function ${FUNCNAME} "${@}"

	if [[ ! ${DISTUTILS_OPTIONAL} ]]; then
		if [[ ${EAPI} != [45] ]]; then
			default
		else
			[[ ${PATCHES} ]] && epatch "${PATCHES[@]}"
			epatch_user
		fi
	fi

	# by default, use in-source build if python_prepare() is used
	if [[ ! ${DISTUTILS_IN_SOURCE_BUILD+1} ]]; then
		if declare -f python_prepare >/dev/null; then
			DISTUTILS_IN_SOURCE_BUILD=1
		fi
	fi

	_distutils-r1_disable_ez_setup
	_distutils-r1_handle_pyproject_toml

	if [[ ${DISTUTILS_IN_SOURCE_BUILD} && ! ${DISTUTILS_SINGLE_IMPL} ]]
	then
		# create source copies for each implementation
		python_copy_sources
	fi

	_DISTUTILS_DEFAULT_CALLED=1
}

# @FUNCTION: distutils-r1_python_prepare
# @DESCRIPTION:
# The default python_prepare(). A no-op.
distutils-r1_python_prepare() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${EAPI} == [45] ]] || die "${FUNCNAME} is banned in EAPI 6 (it was a no-op)"
}

# @FUNCTION: distutils-r1_python_configure
# @DESCRIPTION:
# The default python_configure(). A no-op.
distutils-r1_python_configure() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${EAPI} == [45] ]] || die "${FUNCNAME} is banned in EAPI 6 (it was a no-op)"
}

# @FUNCTION: _distutils-r1_create_setup_cfg
# @INTERNAL
# @DESCRIPTION:
# Create implementation-specific configuration file for distutils,
# setting proper build-dir (and install-dir) paths.
_distutils-r1_create_setup_cfg() {
	cat > "${HOME}"/.pydistutils.cfg <<-_EOF_ || die
		[build]
		build-base = ${BUILD_DIR}

		# using a single directory for them helps us export
		# ${PYTHONPATH} and ebuilds find the sources independently
		# of whether the package installs extensions or not
		#
		# note: due to some packages (wxpython) relying on separate
		# platlib & purelib dirs, we do not set --build-lib (which
		# can not be overridden with --build-*lib)
		build-platlib = %(build-base)s/lib
		build-purelib = %(build-base)s/lib

		# make the ebuild writer lives easier
		build-scripts = %(build-base)s/scripts

		# this is needed by distutils_install_for_testing since
		# setuptools like to create .egg files for install --home.
		[bdist_egg]
		dist-dir = ${BUILD_DIR}/dist
	_EOF_

	# we can't refer to ${D} before src_install()
	if [[ ${EBUILD_PHASE} == install ]]; then
		cat >> "${HOME}"/.pydistutils.cfg <<-_EOF_ || die

			# installation paths -- allow calling extra install targets
			# without the default 'install'
			[install]
			compile = True
			optimize = 2
			root = ${D%/}
		_EOF_

		if [[ ! ${DISTUTILS_SINGLE_IMPL} ]]; then
			cat >> "${HOME}"/.pydistutils.cfg <<-_EOF_ || die
				install-scripts = $(python_get_scriptdir)
			_EOF_
		fi
	fi
}

# @FUNCTION: _distutils-r1_copy_egg_info
# @INTERNAL
# @DESCRIPTION:
# Copy egg-info files to the ${BUILD_DIR} (that's going to become
# egg-base in esetup.py). This way, we respect whatever's in upstream
# egg-info.
_distutils-r1_copy_egg_info() {
	mkdir -p "${BUILD_DIR}" || die
	# stupid freebsd can't do 'cp -t ${BUILD_DIR} {} +'
	find -name '*.egg-info' -type d -exec cp -R -p {} "${BUILD_DIR}"/ ';' || die
}

# @FUNCTION: distutils-r1_python_compile
# @USAGE: [additional-args...]
# @DESCRIPTION:
# The default python_compile(). Runs 'esetup.py build'. Any parameters
# passed to this function will be appended to setup.py invocation,
# i.e. passed as options to the 'build' command.
#
# This phase also sets up initial setup.cfg with build directories
# and copies upstream egg-info files if supplied.
distutils-r1_python_compile() {
	debug-print-function ${FUNCNAME} "${@}"

	_distutils-r1_copy_egg_info

	local build_args=()
	# distutils is parallel-capable since py3.5
	# to avoid breaking stable ebuilds, enable it only if either:
	# a. we're dealing with EAPI 7
	# b. we're dealing with Python 3.7 or PyPy3
	if python_is_python3 && [[ ${EPYTHON} != python3.4 ]]; then
		if [[ ${EAPI} != [56] || ${EPYTHON} != python3.[56] ]]; then
			local jobs=$(makeopts_jobs "${MAKEOPTS}" INF)
			if [[ ${jobs} == INF ]]; then
				local nproc=$(get_nproc)
				jobs=$(( nproc + 1 ))
			fi
			build_args+=( -j "${jobs}" )
		fi
	fi

	esetup.py build "${build_args[@]}" "${@}"
}

# @FUNCTION: _distutils-r1_wrap_scripts
# @USAGE: <path> <bindir>
# @INTERNAL
# @DESCRIPTION:
# Moves and wraps all installed scripts/executables as necessary.
_distutils-r1_wrap_scripts() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${#} -eq 2 ]] || die "usage: ${FUNCNAME} <path> <bindir>"
	local path=${1}
	local bindir=${2}

	local scriptdir=$(python_get_scriptdir)
	local f python_files=() non_python_files=()

	if [[ -d ${path}${scriptdir} ]]; then
		for f in "${path}${scriptdir}"/*; do
			[[ -d ${f} ]] && die "Unexpected directory: ${f}"
			debug-print "${FUNCNAME}: found executable at ${f#${path}/}"

			local shebang
			read -r shebang < "${f}"
			if [[ ${shebang} == '#!'*${EPYTHON}* ]]; then
				debug-print "${FUNCNAME}: matching shebang: ${shebang}"
				python_files+=( "${f}" )
			else
				debug-print "${FUNCNAME}: non-matching shebang: ${shebang}"
				non_python_files+=( "${f}" )
			fi

			mkdir -p "${path}${bindir}" || die
		done

		for f in "${python_files[@]}"; do
			local basename=${f##*/}

			debug-print "${FUNCNAME}: installing wrapper at ${bindir}/${basename}"
			_python_ln_rel "${path}${EPREFIX}"/usr/lib/python-exec/python-exec2 \
				"${path}${bindir}/${basename}" || die
		done

		for f in "${non_python_files[@]}"; do
			local basename=${f##*/}

			debug-print "${FUNCNAME}: moving ${f#${path}/} to ${bindir}/${basename}"
			mv "${f}" "${path}${bindir}/${basename}" || die
		done
	fi
}

# @FUNCTION: distutils-r1_python_install
# @USAGE: [additional-args...]
# @DESCRIPTION:
# The default python_install(). Runs 'esetup.py install', doing
# intermediate root install and handling script wrapping afterwards.
# Any parameters passed to this function will be appended
# to the setup.py invocation (i.e. as options to the 'install' command).
#
# This phase updates the setup.cfg file with install directories.
distutils-r1_python_install() {
	debug-print-function ${FUNCNAME} "${@}"

	local args=( "${@}" )

	# enable compilation for the install phase.
	local -x PYTHONDONTWRITEBYTECODE=

	# python likes to compile any module it sees, which triggers sandbox
	# failures if some packages haven't compiled their modules yet.
	addpredict "${EPREFIX}/usr/lib/${EPYTHON}"
	addpredict "${EPREFIX}/usr/$(get_libdir)/${EPYTHON}"
	addpredict /usr/lib/pypy2.7
	addpredict /usr/lib/pypy3.6
	addpredict /usr/lib/portage/pym
	addpredict /usr/local # bug 498232

	if [[ ! ${DISTUTILS_SINGLE_IMPL} ]]; then
		# user may override --install-scripts
		# note: this is poor but distutils argv parsing is dumb
		local mydistutilsargs=( "${mydistutilsargs[@]}" )
		local scriptdir=${EPREFIX}/usr/bin

		# construct a list of mydistutilsargs[0] args[0] args[1]...
		local arg arg_vars
		[[ ${mydistutilsargs[@]} ]] && eval arg_vars+=(
			'mydistutilsargs['{0..$(( ${#mydistutilsargs[@]} - 1 ))}']'
		)
		[[ ${args[@]} ]] && eval arg_vars+=(
			'args['{0..$(( ${#args[@]} - 1 ))}']'
		)

		set -- "${arg_vars[@]}"
		while [[ ${@} ]]; do
			local arg_var=${1}
			shift
			local a=${!arg_var}

			case "${a}" in
				--install-scripts=*)
					scriptdir=${a#--install-scripts=}
					unset "${arg_var}"
					;;
				--install-scripts)
					scriptdir=${!1}
					unset "${arg_var}" "${1}"
					shift
					;;
			esac
		done
	fi

	local root=${D%/}/_${EPYTHON}
	[[ ${DISTUTILS_SINGLE_IMPL} ]] && root=${D%/}

	esetup.py install --skip-build --root="${root}" "${args[@]}"

	local forbidden_package_names=( examples test tests .pytest_cache )
	local p
	for p in "${forbidden_package_names[@]}"; do
		if [[ -d ${root}$(python_get_sitedir)/${p} ]]; then
			die "Package installs '${p}' package which is forbidden and likely a bug in the build system."
		fi
	done

	local shopt_save=$(shopt -p nullglob)
	shopt -s nullglob
	local pypy_dirs=(
		"${root}/usr/$(get_libdir)"/pypy*/share
		"${root}/usr/lib"/pypy*/share
	)
	${shopt_save}

	if [[ -n ${pypy_dirs} ]]; then
		die "Package installs 'share' in PyPy prefix, see bug #465546."
	fi

	if [[ ! ${DISTUTILS_SINGLE_IMPL} ]]; then
		_distutils-r1_wrap_scripts "${root}" "${scriptdir}"
		multibuild_merge_root "${root}" "${D%/}"
	fi
}

# @FUNCTION: distutils-r1_python_install_all
# @DESCRIPTION:
# The default python_install_all(). It installs the documentation.
distutils-r1_python_install_all() {
	debug-print-function ${FUNCNAME} "${@}"

	einstalldocs

	if declare -p EXAMPLES &>/dev/null; then
		[[ ${EAPI} != [45] ]] && die "EXAMPLES are banned in EAPI ${EAPI}"

		(
			docinto examples
			dodoc -r "${EXAMPLES[@]}"
		)
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
}

# @FUNCTION: distutils-r1_run_phase
# @USAGE: [<argv>...]
# @INTERNAL
# @DESCRIPTION:
# Run the given command.
#
# If out-of-source builds are used, the phase function is run in source
# directory, with BUILD_DIR pointing at the build directory
# and PYTHONPATH having an entry for the module build directory.
#
# If in-source builds are used, the command is executed in the directory
# holding the per-implementation copy of sources. BUILD_DIR points
# to the 'build' subdirectory.
distutils-r1_run_phase() {
	debug-print-function ${FUNCNAME} "${@}"

	if [[ ${DISTUTILS_IN_SOURCE_BUILD} ]]; then
		# only force BUILD_DIR if implementation is explicitly enabled
		# for building; any-r1 API may select one that is not
		# https://bugs.gentoo.org/701506
		if [[ ! ${DISTUTILS_SINGLE_IMPL} ]] &&
				has "${EPYTHON/./_}" ${PYTHON_TARGETS}; then
			cd "${BUILD_DIR}" || die
		fi
		local BUILD_DIR=${BUILD_DIR}/build
	fi
	local -x PYTHONPATH="${BUILD_DIR}/lib:${PYTHONPATH}"

	# Bug 559644
	# using PYTHONPATH when the ${BUILD_DIR}/lib is not created yet might lead to
	# problems in setup.py scripts that try to import modules/packages from that path
	# during the build process (Python at startup evaluates PYTHONPATH, if the dir is
	# not valid then associates a NullImporter object to ${BUILD_DIR}/lib storing it
	# in the sys.path_importer_cache)
	mkdir -p "${BUILD_DIR}/lib" || die

	# Set up build environment, bug #513664.
	local -x AR=${AR} CC=${CC} CPP=${CPP} CXX=${CXX}
	tc-export AR CC CPP CXX

	# How to build Python modules in different worlds...
	local ldopts
	case "${CHOST}" in
		# provided by haubi, 2014-07-08
		*-aix*) ldopts='-shared -Wl,-berok';; # good enough
		# provided by grobian, 2014-06-22, bug #513664 c7
		*-darwin*) ldopts='-bundle -undefined dynamic_lookup';;
		*) ldopts='-shared';;
	esac

	local -x LDSHARED="${CC} ${ldopts}" LDCXXSHARED="${CXX} ${ldopts}"

	"${@}"

	cd "${_DISTUTILS_INITIAL_CWD}" || die
}

# @FUNCTION: _distutils-r1_run_common_phase
# @USAGE: [<argv>...]
# @INTERNAL
# @DESCRIPTION:
# Run the given command, restoring the state for a most preferred Python
# implementation matching DISTUTILS_ALL_SUBPHASE_IMPLS.
#
# If in-source build is used, the command will be run in the copy
# of sources made for the selected Python interpreter.
_distutils-r1_run_common_phase() {
	local DISTUTILS_ORIG_BUILD_DIR=${BUILD_DIR}

	if [[ ${DISTUTILS_SINGLE_IMPL} ]]; then
		# reuse the dedicated code branch
		_distutils-r1_run_foreach_impl "${@}"
	else
		local -x EPYTHON PYTHON
		local -x PATH=${PATH} PKG_CONFIG_PATH=${PKG_CONFIG_PATH}
		python_setup "${DISTUTILS_ALL_SUBPHASE_IMPLS[@]}"

		local MULTIBUILD_VARIANTS=( "${EPYTHON/./_}" )
		# store for restoring after distutils-r1_run_phase.
		local _DISTUTILS_INITIAL_CWD=${PWD}
		multibuild_foreach_variant \
			distutils-r1_run_phase "${@}"
	fi
}

# @FUNCTION: _distutils-r1_run_foreach_impl
# @INTERNAL
# @DESCRIPTION:
# Run the given phase for each implementation if multiple implementations
# are enabled, once otherwise.
_distutils-r1_run_foreach_impl() {
	debug-print-function ${FUNCNAME} "${@}"

	# store for restoring after distutils-r1_run_phase.
	local _DISTUTILS_INITIAL_CWD=${PWD}
	set -- distutils-r1_run_phase "${@}"

	if [[ ! ${DISTUTILS_SINGLE_IMPL} ]]; then
		python_foreach_impl "${@}"
	else
		if [[ ! ${EPYTHON} ]]; then
			die "EPYTHON unset, python-single-r1_pkg_setup not called?!"
		fi
		local BUILD_DIR=${BUILD_DIR:-${S}}
		BUILD_DIR=${BUILD_DIR%%/}_${EPYTHON}

		"${@}"
	fi
}

distutils-r1_src_prepare() {
	debug-print-function ${FUNCNAME} "${@}"

	local _DISTUTILS_DEFAULT_CALLED

	# common preparations
	if declare -f python_prepare_all >/dev/null; then
		python_prepare_all
	else
		distutils-r1_python_prepare_all
	fi

	if [[ ! ${_DISTUTILS_DEFAULT_CALLED} ]]; then
		local cmd=die
		[[ ${EAPI} == [45] ]] && cmd=eqawarn

		"${cmd}" "QA: python_prepare_all() didn't call distutils-r1_python_prepare_all"
	fi

	if declare -f python_prepare >/dev/null; then
		_distutils-r1_run_foreach_impl python_prepare
	fi
}

distutils-r1_src_configure() {
	python_export_utf8_locale
	[[ ${EAPI} == [56] ]] && xdg_environment_reset # Bug 577704

	if declare -f python_configure >/dev/null; then
		_distutils-r1_run_foreach_impl python_configure
	fi

	if declare -f python_configure_all >/dev/null; then
		_distutils-r1_run_common_phase python_configure_all
	fi
}

distutils-r1_src_compile() {
	debug-print-function ${FUNCNAME} "${@}"

	if declare -f python_compile >/dev/null; then
		_distutils-r1_run_foreach_impl python_compile
	else
		_distutils-r1_run_foreach_impl distutils-r1_python_compile
	fi

	if declare -f python_compile_all >/dev/null; then
		_distutils-r1_run_common_phase python_compile_all
	fi
}

# @FUNCTION: _distutils-r1_clean_egg_info
# @INTERNAL
# @DESCRIPTION:
# Clean up potential stray egg-info files left by setuptools test phase.
# Those files ended up being unversioned, and caused issues:
# https://bugs.gentoo.org/534058
_distutils-r1_clean_egg_info() {
	rm -rf "${BUILD_DIR}"/lib/*.egg-info || die
}

distutils-r1_src_test() {
	debug-print-function ${FUNCNAME} "${@}"

	if declare -f python_test >/dev/null; then
		_distutils-r1_run_foreach_impl python_test
		_distutils-r1_run_foreach_impl _distutils-r1_clean_egg_info
	fi

	if declare -f python_test_all >/dev/null; then
		_distutils-r1_run_common_phase python_test_all
	fi
}

# @FUNCTION: _distutils-r1_check_namespace_pth
# @INTERNAL
# @DESCRIPTION:
# Check if any *-nspkg.pth files were installed (by setuptools)
# and warn about the policy non-conformance if they were.
_distutils-r1_check_namespace_pth() {
	local f pth=()

	while IFS= read -r -d '' f; do
		pth+=( "${f}" )
	done < <(find "${ED%/}" -name '*-nspkg.pth' -print0)

	if [[ ${pth[@]} ]]; then
		ewarn "The following *-nspkg.pth files were found installed:"
		ewarn
		for f in "${pth[@]}"; do
			ewarn "  ${f#${ED%/}}"
		done
		ewarn
		ewarn "The presence of those files may break namespaces in Python 3.5+. Please"
		ewarn "read our documentation on reliable handling of namespaces and update"
		ewarn "the ebuild accordingly:"
		ewarn
		ewarn "  https://wiki.gentoo.org/wiki/Project:Python/Namespace_packages"
	fi
}

distutils-r1_src_install() {
	debug-print-function ${FUNCNAME} "${@}"

	if declare -f python_install >/dev/null; then
		_distutils-r1_run_foreach_impl python_install
	else
		_distutils-r1_run_foreach_impl distutils-r1_python_install
	fi

	if declare -f python_install_all >/dev/null; then
		_distutils-r1_run_common_phase python_install_all
	else
		_distutils-r1_run_common_phase distutils-r1_python_install_all
	fi

	_distutils-r1_check_namespace_pth
}

# -- distutils.eclass functions --

distutils_get_intermediate_installation_image() {
	die "${FUNCNAME}() is invalid for distutils-r1"
}

distutils_src_unpack() {
	die "${FUNCNAME}() is invalid for distutils-r1, and you don't want it in EAPI ${EAPI} anyway"
}

distutils_src_prepare() {
	die "${FUNCNAME}() is invalid for distutils-r1, you probably want: ${FUNCNAME/_/-r1_}"
}

distutils_src_compile() {
	die "${FUNCNAME}() is invalid for distutils-r1, you probably want: ${FUNCNAME/_/-r1_}"
}

distutils_src_test() {
	die "${FUNCNAME}() is invalid for distutils-r1, you probably want: ${FUNCNAME/_/-r1_}"
}

distutils_src_install() {
	die "${FUNCNAME}() is invalid for distutils-r1, you probably want: ${FUNCNAME/_/-r1_}"
}

distutils_pkg_postinst() {
	die "${FUNCNAME}() is invalid for distutils-r1, and pkg_postinst is unnecessary"
}

distutils_pkg_postrm() {
	die "${FUNCNAME}() is invalid for distutils-r1, and pkg_postrm is unnecessary"
}

_DISTUTILS_R1=1
fi
