# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: distutils-r1.eclass
# @MAINTAINER:
# Python team <python@gentoo.org>
# @AUTHOR:
# Author: Michał Górny <mgorny@gentoo.org>
# Based on the work of: Krzysztof Pawlik <nelchael@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @PROVIDES: python-r1 python-single-r1
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
# Please note that distutils-r1 sets RDEPEND and BDEPEND (or DEPEND
# in earlier EAPIs) unconditionally for you.
#
# Also, please note that distutils-r1 will always inherit python-r1
# as well. Thus, all the variables defined and documented there are
# relevant to the packages using distutils-r1.
#
# For more information, please see the Python Guide:
# https://projects.gentoo.org/python/guide/

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# @ECLASS_VARIABLE: DISTUTILS_EXT
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set this variable to a non-null value if the package (possibly
# optionally) builds Python extensions (loadable modules written in C,
# Cython, Rust, etc.).
#
# When enabled, the eclass:
#
# - adds PYTHON_DEPS to DEPEND (for cross-compilation support), unless
#   DISTUTILS_OPTIONAL is used
#
# - adds `debug` flag to IUSE that controls assertions (i.e. -DNDEBUG)
#
# - calls `build_ext` command if setuptools build backend is used
#   and there is potential benefit from parallel builds

# @ECLASS_VARIABLE: DISTUTILS_OPTIONAL
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

# @ECLASS_VARIABLE: DISTUTILS_SINGLE_IMPL
# @DEFAULT_UNSET
# @DESCRIPTION:
# If set to a non-null value, the ebuild will support setting a single
# Python implementation only. It will effectively replace the python-r1
# eclass inherit with python-single-r1.
#
# Note that inheriting python-single-r1 will cause pkg_setup()
# to be exported. It must be run in order for the eclass functions
# to function properly.

# @ECLASS_VARIABLE: DISTUTILS_USE_PEP517
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# Enable the PEP 517 mode for the specified build system.  In this mode,
# the complete build and install is done in python_compile(),
# a venv-style install tree is provided to python_test(),
# and python_install() just merges the temporary install tree
# into the real fs.
#
# This mode is recommended for Python packages.  However, some packages
# using custom hacks on top of distutils/setuptools may not install
# correctly in this mode.  Please verify the list of installed files
# when using it.
#
# The variable specifies the build system used.  Currently,
# the following values are supported:
#
# - flit - flit-core backend
#
# - flit_scm - flit_scm backend
#
# - hatchling - hatchling backend (from hatch)
#
# - jupyter - jupyter_packaging backend
#
# - maturin - maturin backend
#
# - meson-python - meson-python (mesonpy) backend
#
# - no - no PEP517 build system (see below)
#
# - pbr - pbr backend
#
# - pdm - pdm.pep517 backend
#
# - pdm-backend - pdm.backend backend
#
# - poetry - poetry-core backend
#
# - setuptools - distutils or setuptools (incl. legacy mode)
#
# - sip - sipbuild backend
#
# - standalone - standalone build systems without external deps
#   (used for bootstrapping).
#
# The variable needs to be set before the inherit line.  The eclass
# adds appropriate build-time dependencies and verifies the value.
#
# The special value "no" indicates that the package has no build system.
# This is not equivalent to unset DISTUTILS_USE_PEP517 (legacy mode).
# It causes the eclass not to include any build system dependencies
# and to disable default python_compile() and python_install()
# implementations.  Baseline Python deps and phase functions will still
# be set (depending on the value of DISTUTILS_OPTIONAL).  Most of
# the other eclass functions will work.  Testing venv will be provided
# in ${BUILD_DIR}/install after python_compile(), and if any (other)
# files are found in ${BUILD_DIR}/install after python_install(), they
# will be merged into ${D}.

# @ECLASS_VARIABLE: DISTUTILS_USE_SETUPTOOLS
# @DEFAULT_UNSET
# @PRE_INHERIT
# @DESCRIPTION:
# Controls adding dev-python/setuptools dependency.  The allowed values
# are:
#
# - no -- do not add the dependency (pure distutils package)
#
# - bdepend -- add it to BDEPEND (the default)
#
# - rdepend -- add it to BDEPEND+RDEPEND (e.g. when using pkg_resources)
#
# - manual -- do not add the dependency and suppress the checks
#   (assumes you will take care of doing it correctly)
#
# This variable is effective only if DISTUTILS_OPTIONAL is disabled.
# It is available only in non-PEP517 mode.  It needs to be set before
# the inherit line.

# @ECLASS_VARIABLE: DISTUTILS_DEPS
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# This is an eclass-generated build-time dependency string for the build
# system packages.  This string is automatically appended to BDEPEND
# unless DISTUTILS_OPTIONAL is used.  This variable is available only
# in PEP 517 mode.
#
# Example use:
# @CODE
# DISTUTILS_OPTIONAL=1
# # ...
# RDEPEND="${PYTHON_DEPS}"
# BDEPEND="
#     ${PYTHON_DEPS}
#     ${DISTUTILS_DEPS}"
# @CODE

if [[ -z ${_DISTUTILS_R1_ECLASS} ]]; then
_DISTUTILS_R1_ECLASS=1

inherit flag-o-matic
inherit multibuild multilib multiprocessing ninja-utils toolchain-funcs

if [[ ! ${DISTUTILS_SINGLE_IMPL} ]]; then
	inherit python-r1
else
	inherit python-single-r1
fi

_distutils_set_globals() {
	local rdep bdep
	if [[ ${DISTUTILS_USE_PEP517} ]]; then
		if [[ ${DISTUTILS_USE_SETUPTOOLS} ]]; then
			die "DISTUTILS_USE_SETUPTOOLS is not used in PEP517 mode"
		fi

		bdep='
			>=dev-python/gpep517-13[${PYTHON_USEDEP}]
		'
		case ${DISTUTILS_USE_PEP517} in
			flit)
				bdep+='
					>=dev-python/flit-core-3.9.0[${PYTHON_USEDEP}]
				'
				;;
			flit_scm)
				bdep+='
					>=dev-python/flit_scm-1.7.0[${PYTHON_USEDEP}]
				'
				;;
			hatchling)
				bdep+='
					>=dev-python/hatchling-1.17.0[${PYTHON_USEDEP}]
				'
				;;
			jupyter)
				bdep+='
					>=dev-python/jupyter-packaging-0.12.3[${PYTHON_USEDEP}]
				'
				;;
			maturin)
				bdep+='
					>=dev-util/maturin-1.0.1[${PYTHON_USEDEP}]
				'
				;;
			no)
				# undo the generic deps added above
				bdep=
				;;
			meson-python)
				bdep+='
					>=dev-python/meson-python-0.13.1[${PYTHON_USEDEP}]
				'
				;;
			pbr)
				bdep+='
					>=dev-python/pbr-5.11.1[${PYTHON_USEDEP}]
				'
				;;
			pdm)
				bdep+='
					>=dev-python/pdm-pep517-1.1.4[${PYTHON_USEDEP}]
				'
				;;
			pdm-backend)
				bdep+='
					>=dev-python/pdm-backend-2.1.0[${PYTHON_USEDEP}]
				'
				;;
			poetry)
				bdep+='
					>=dev-python/poetry-core-1.6.1[${PYTHON_USEDEP}]
				'
				;;
			scikit-build-core)
				bdep+='
					>=dev-python/scikit-build-core-0.4.6[${PYTHON_USEDEP}]
				'
				;;
			setuptools)
				bdep+='
					>=dev-python/setuptools-67.8.0-r1[${PYTHON_USEDEP}]
				'
				;;
			sip)
				bdep+='
					>=dev-python/sip-6.7.9[${PYTHON_USEDEP}]
				'
				;;
			standalone)
				;;
			*)
				die "Unknown DISTUTILS_USE_PEP517=${DISTUTILS_USE_PEP517}"
				;;
		esac
	elif [[ ${DISTUTILS_OPTIONAL} ]]; then
		if [[ ${DISTUTILS_USE_SETUPTOOLS} ]]; then
			eqawarn "QA Notice: DISTUTILS_USE_SETUPTOOLS is not used when DISTUTILS_OPTIONAL"
			eqawarn "is enabled."
		fi
	else
		local setuptools_dep='>=dev-python/setuptools-67.8.0-r1[${PYTHON_USEDEP}]'

		case ${DISTUTILS_USE_SETUPTOOLS:-bdepend} in
			no|manual)
				;;
			bdepend)
				bdep+=" ${setuptools_dep}"
				;;
			rdepend)
				bdep+=" ${setuptools_dep}"
				rdep+=" ${setuptools_dep}"
				;;
			pyproject.toml)
				die "DISTUTILS_USE_SETUPTOOLS=pyproject.toml is no longer supported, use DISTUTILS_USE_PEP517"
				;;
			*)
				die "Invalid DISTUTILS_USE_SETUPTOOLS=${DISTUTILS_USE_SETUPTOOLS}"
				;;
		esac
	fi

	if [[ ! ${DISTUTILS_SINGLE_IMPL} ]]; then
		bdep=${bdep//\$\{PYTHON_USEDEP\}/${PYTHON_USEDEP}}
		rdep=${rdep//\$\{PYTHON_USEDEP\}/${PYTHON_USEDEP}}
	else
		[[ -n ${bdep} ]] && bdep="$(python_gen_cond_dep "${bdep}")"
		[[ -n ${rdep} ]] && rdep="$(python_gen_cond_dep "${rdep}")"
	fi

	if [[ ${DISTUTILS_USE_PEP517} ]]; then
		if [[ ${DISTUTILS_DEPS+1} ]]; then
			if [[ ${DISTUTILS_DEPS} != "${bdep}" ]]; then
				eerror "DISTUTILS_DEPS have changed between inherits!"
				eerror "Before: ${DISTUTILS_DEPS}"
				eerror "Now   : ${bdep}"
				die "DISTUTILS_DEPS integrity check failed"
			fi
		else
			DISTUTILS_DEPS=${bdep}
			readonly DISTUTILS_DEPS
		fi
	fi

	if [[ ! ${DISTUTILS_OPTIONAL} ]]; then
		RDEPEND="${PYTHON_DEPS} ${rdep}"
		BDEPEND="${PYTHON_DEPS} ${bdep}"
		REQUIRED_USE=${PYTHON_REQUIRED_USE}

		if [[ ${DISTUTILS_EXT} ]]; then
			DEPEND="${PYTHON_DEPS}"
		fi
	fi

	if [[ ${DISTUTILS_EXT} ]]; then
		IUSE="debug"
	fi
}
_distutils_set_globals
unset -f _distutils_set_globals

# @ECLASS_VARIABLE: PATCHES
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

# @ECLASS_VARIABLE: DOCS
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

# @ECLASS_VARIABLE: HTML_DOCS
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

# @ECLASS_VARIABLE: DISTUTILS_IN_SOURCE_BUILD
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

# @ECLASS_VARIABLE: DISTUTILS_ALL_SUBPHASE_IMPLS
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array of patterns specifying which implementations can be used
# for *_all() sub-phase functions. If undefined, defaults to '*'
# (allowing any implementation). If multiple values are specified,
# implementations matching any of the patterns will be accepted.
#
# For the pattern syntax, please see _python_impl_matches
# in python-utils-r1.eclass.
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

# @ECLASS_VARIABLE: DISTUTILS_ARGS
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array containing options to be passed to the build system.
# Supported by a subset of build systems used by the eclass.
#
# For setuptools, the arguments will be passed as first parameters
# to setup.py invocations (via esetup.py), as well as to the PEP517
# backend.  For future compatibility, only global options should be used
# and specifying commands should be avoided.
#
# For sip, the options are passed to the PEP517 backend in a form
# resembling sip-build calls.  Options taking arguments need to
# be specified in the "--key=value" form, while flag options as "--key".
# If an option takes multiple arguments, it can be specified multiple
# times, same as for sip-build.
#
# Example:
# @CODE
# python_configure_all() {
# 	DISTUTILS_ARGS=( --enable-my-hidden-option )
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
# aforementioned functions.  If you need to use a custom implementation,
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
	deps=">=dev-python/sphinx-5.3.0[\${PYTHON_USEDEP}]"
	for d; do
		if [[ ${d} == --no-autodoc ]]; then
			autodoc=
		else
			deps+="
				${d}[\${PYTHON_USEDEP}]"
			if [[ ! ${autodoc} ]]; then
				die "${FUNCNAME}: do not pass --no-autodoc if external plugins are used"
			fi
		fi
	done

	if [[ ${autodoc} ]]; then
		if [[ ${DISTUTILS_SINGLE_IMPL} ]]; then
			deps="$(python_gen_cond_dep "${deps}")"
		else
			deps="$(python_gen_any_dep "${deps}")"
		fi

		python_check_deps() {
			use doc || return 0

			local p
			for p in ">=dev-python/sphinx-5.3.0" \
				"${_DISTUTILS_SPHINX_PLUGINS[@]}"
			do
				python_has_version "${p}[${PYTHON_USEDEP}]" ||
					return 1
			done
		}
	else
		deps=">=dev-python/sphinx-5.3.0"
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
	BDEPEND+=" doc? ( ${deps} )"

	# we need to ensure successful return in case we're called last,
	# otherwise Portage may wrongly assume sourcing failed
	return 0
}

# @FUNCTION: distutils_enable_tests
# @USAGE: [--install] <test-runner>
# @DESCRIPTION:
# Set up IUSE, RESTRICT, BDEPEND and python_test() for running tests
# with the specified test runner.  Also copies the current value
# of RDEPEND to test?-BDEPEND.  The test-runner argument must be one of:
#
# - nose: nosetests (dev-python/nose)
#
# - pytest: dev-python/pytest
#
# - setup.py: setup.py test (no deps included)
#
# - unittest: for built-in Python unittest module
#
# Additionally, if --install is passed as the first parameter,
# 'distutils_install_for_testing --via-root' is called before running
# the test suite.
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

	_DISTUTILS_TEST_INSTALL=
	case ${1} in
		--install)
			if [[ ${DISTUTILS_USE_PEP517} ]]; then
				die "${FUNCNAME} --install is not implemented in PEP517 mode"
			fi
			_DISTUTILS_TEST_INSTALL=1
			shift
			;;
	esac

	[[ ${#} -eq 1 ]] || die "${FUNCNAME} takes exactly one argument: test-runner"
	local test_pkg
	case ${1} in
		nose)
			test_pkg=">=dev-python/nose-1.3.7_p20221026"
			;;
		pytest)
			test_pkg=">=dev-python/pytest-7.3.1"
			;;
		setup.py)
			;;
		unittest)
			# dep handled below
			;;
		*)
			die "${FUNCNAME}: unsupported argument: ${1}"
	esac

	_DISTUTILS_TEST_RUNNER=${1}
	python_test() { distutils-r1_python_test; }

	local test_deps=${RDEPEND}
	if [[ -n ${test_pkg} ]]; then
		if [[ ! ${DISTUTILS_SINGLE_IMPL} ]]; then
			test_deps+=" ${test_pkg}[${PYTHON_USEDEP}]"
		else
			test_deps+=" $(python_gen_cond_dep "
				${test_pkg}[\${PYTHON_USEDEP}]
			")"
		fi
	elif [[ ${1} == unittest ]]; then
		# unittest-or-fail is needed in py<3.12
		test_deps+="
			$(python_gen_cond_dep '
				dev-python/unittest-or-fail[${PYTHON_USEDEP}]
			' 3.{9..11})
		"
	fi
	if [[ -n ${test_deps} ]]; then
		IUSE+=" test"
		RESTRICT+=" !test? ( test )"
		BDEPEND+=" test? ( ${test_deps} )"
	fi

	# we need to ensure successful return in case we're called last,
	# otherwise Portage may wrongly assume sourcing failed
	return 0
}

# @FUNCTION: esetup.py
# @USAGE: [<args>...]
# @DESCRIPTION:
# Run setup.py using currently selected Python interpreter
# (if ${EPYTHON} is set; fallback 'python' otherwise).
#
# setup.py will be passed the following, in order:
#
# 1. ${DISTUTILS_ARGS[@]}
#
# 2. ${mydistutilsargs[@]} (deprecated)
#
# 3. additional arguments passed to the esetup.py function.
#
# Please note that setup.py will respect defaults (unless overridden
# via command-line options) from setup.cfg that is created
# in distutils-r1_python_compile and in distutils-r1_python_install.
#
# This command dies on failure.
esetup.py() {
	debug-print-function ${FUNCNAME} "${@}"

	_python_check_EPYTHON

	if [[ ${BUILD_DIR} && ! ${DISTUTILS_USE_PEP517} ]]; then
		_distutils-r1_create_setup_cfg
	fi

	local setup_py=( setup.py )
	if [[ ! -f setup.py ]]; then
		# The following call can succeed even if the package does not
		# feature any setuptools configuration.  In non-PEP517 mode this
		# could lead to installing an "empty" package.  In PEP517 mode,
		# we verify the build system when invoking the backend,
		# rendering this check redundant (and broken for projects using
		# pyproject.toml configuration).
		if [[ ! ${DISTUTILS_USE_PEP517} && ! -f setup.cfg ]]; then
			die "${FUNCNAME}: setup.py nor setup.cfg not found"
		fi
		setup_py=( -c "from setuptools import setup; setup()" )
	fi

	if [[ ${EAPI} != 7 && ${mydistutilsargs[@]} ]]; then
		die "mydistutilsargs is banned in EAPI ${EAPI} (use DISTUTILS_ARGS)"
	fi

	set -- "${EPYTHON}" "${setup_py[@]}" "${DISTUTILS_ARGS[@]}" \
		"${mydistutilsargs[@]}" "${@}"

	echo "${@}" >&2
	"${@}" || die -n
	local ret=${?}

	if [[ ${BUILD_DIR} && ! ${DISTUTILS_USE_PEP517} ]]; then
		rm "${HOME}"/.pydistutils.cfg || die -n
	fi

	return ${ret}
}

# @FUNCTION: distutils_install_for_testing
# @USAGE: [--via-root|--via-home|--via-venv] [<args>...]
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
#
# The function supports three install modes.  These are:
#
# --via-root (the default) that uses 'setup.py install --root=...'
# combined with PYTHONPATH and is recommended for the majority
# of packages.
#
# --via-venv that creates a (non-isolated) venv and installs the package
# into it via 'setup.py install'.  This mode does not use PYTHONPATH
# but requires python to be called via PATH.  It may solve a few corner
# cases that --via-root do not support.
#
# --via-home that uses 'setup.py install --home=...'.  This is
# a historical mode that was mostly broken by setuptools 50.3.0+.
# If your package does not work with the other two modes but works with
# this one, please report a bug.
#
# Please note that in order to test the solution properly you need
# to unmerge the package first.
#
# This function is not available in PEP517 mode.  The eclass provides
# a venv-style install unconditionally and therefore it should no longer
# be necessary.
distutils_install_for_testing() {
	debug-print-function ${FUNCNAME} "${@}"

	if [[ ${DISTUTILS_USE_PEP517} ]]; then
		die "${FUNCNAME} is not implemented in PEP517 mode"
	fi

	# A few notes about --via-home mode:
	# 1) 'install --home' is terribly broken on pypy, so we need
	#    to override --install-lib and --install-scripts,
	# 2) non-root 'install' complains about PYTHONPATH and missing dirs,
	#    so we need to set it properly and mkdir them,
	# 3) it runs a bunch of commands which write random files to cwd,
	#    in order to avoid that, we add the necessary path overrides
	#    in _distutils-r1_create_setup_cfg.

	local install_method=root
	case ${1} in
		--via-home)
			[[ ${EAPI} == 7 ]] || die "${*} is banned in EAPI ${EAPI}"
			install_method=home
			shift
			;;
		--via-root)
			install_method=root
			shift
			;;
		--via-venv)
			install_method=venv
			shift
			;;
	esac

	TEST_DIR=${BUILD_DIR}/test
	local add_args=()

	if [[ ${install_method} == venv ]]; then
		# create a quasi-venv
		mkdir -p "${TEST_DIR}"/bin || die
		ln -s "${PYTHON}" "${TEST_DIR}/bin/${EPYTHON}" || die
		ln -s "${EPYTHON}" "${TEST_DIR}/bin/python3" || die
		ln -s "${EPYTHON}" "${TEST_DIR}/bin/python" || die
		cat > "${TEST_DIR}"/pyvenv.cfg <<-EOF || die
			include-system-site-packages = true
		EOF

		# we only do the minimal necessary subset of activate script
		PATH=${TEST_DIR}/bin:${PATH}
		# unset PYTHONPATH in order to prevent BUILD_DIR from overriding
		# venv packages
		unset PYTHONPATH

		# force root-style install (note: venv adds TEST_DIR to prefixes,
		# so we need to pass --root=/)
		add_args=(
			--root=/
		)
	else
		local bindir=${TEST_DIR}/scripts
		local libdir=${TEST_DIR}/lib
		PATH=${bindir}:${PATH}
		PYTHONPATH=${libdir}:${PYTHONPATH}

		case ${install_method} in
			home)
				add_args=(
					--home="${TEST_DIR}"
					--install-lib="${libdir}"
					--install-scripts="${bindir}"
				)
				mkdir -p "${libdir}" || die
				;;
			root)
				add_args=(
					--root="${TEST_DIR}"
					--install-lib=lib
					--install-scripts=scripts
				)
				;;
		esac
	fi

	esetup.py install "${add_args[@]}" "${@}"
}

# @FUNCTION: distutils_write_namespace
# @USAGE: <namespace>...
# @DESCRIPTION:
# Write the __init__.py file for the requested namespace into PEP517
# install tree, in order to fix running tests when legacy namespace
# packages are installed (dev-python/namespace-*).
#
# This function must only be used in python_test().  The created file
# will automatically be removed upon leaving the test phase.
distutils_write_namespace() {
	debug-print-function ${FUNCNAME} "${@}"

	if [[ ! ${DISTUTILS_USE_PEP517:-no} != no ]]; then
		die "${FUNCNAME} is available only in PEP517 mode"
	fi
	if [[ ${EBUILD_PHASE} != test || ! ${BUILD_DIR} ]]; then
		die "${FUNCNAME} should only be used in python_test"
	fi

	local namespace
	for namespace; do
		if [[ ${namespace} == *[./]* ]]; then
			die "${FUNCNAME} does not support nested namespaces at the moment"
		fi

		local path=${BUILD_DIR}/install$(python_get_sitedir)/${namespace}/__init__.py
		if [[ -f ${path} ]]; then
			die "Requested namespace ${path} exists already!"
		fi
		cat > "${path}" <<-EOF || die
			__path__ = __import__('pkgutil').extend_path(__path__, __name__)
		EOF
		_DISTUTILS_POST_PHASE_RM+=( "${path}" )
	done
}

# @FUNCTION: _distutils-r1_disable_ez_setup
# @INTERNAL
# @DESCRIPTION:
# Stub out ez_setup.py and distribute_setup.py to prevent packages
# from trying to download a local copy of setuptools.
_distutils-r1_disable_ez_setup() {
	if [[ ${DISTUTILS_USE_PEP517} ]]; then
		die "${FUNCNAME} is not implemented in PEP517 mode"
	fi

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
# Verify whether DISTUTILS_USE_SETUPTOOLS is set correctly
# for pyproject.toml build systems (in non-PEP517 mode).
_distutils-r1_handle_pyproject_toml() {
	if [[ ${DISTUTILS_USE_PEP517} ]]; then
		die "${FUNCNAME} is not implemented in PEP517 mode"
	fi

	[[ ${DISTUTILS_USE_SETUPTOOLS} == manual ]] && return

	if [[ ! -f setup.py && -f pyproject.toml ]]; then
		eerror "No setup.py found but pyproject.toml is present.  Please migrate"
		eerror "the package to use DISTUTILS_USE_PEP517. See:"
		eerror "  https://projects.gentoo.org/python/guide/distutils.html"
		die "No setup.py found and PEP517 mode not enabled"
	fi
}

# @FUNCTION: _distutils-r1_check_all_phase_mismatch
# @INTERNAL
# @DESCRIPTION:
# Verify whether *_all phase impls is not called from from non-*_all
# subphase.
_distutils-r1_check_all_phase_mismatch() {
	if has "python_${EBUILD_PHASE}" "${FUNCNAME[@]}"; then
		eqawarn "QA Notice: distutils-r1_python_${EBUILD_PHASE}_all called"
		eqawarn "from python_${EBUILD_PHASE}.  Did you mean to use"
		eqawarn "python_${EBUILD_PHASE}_all()?"
		[[ ${EAPI} != 7 ]] &&
			die "distutils-r1_python_${EBUILD_PHASE}_all called from python_${EBUILD_PHASE}."
	fi
}

# @FUNCTION: _distutils-r1_print_package_versions
# @INTERNAL
# @DESCRIPTION:
# Print the version of the relevant build system packages to aid
# debugging.
_distutils-r1_print_package_versions() {
	local packages=()

	if [[ ${DISTUTILS_USE_PEP517} ]]; then
		packages+=(
			dev-python/gpep517
			dev-python/installer
		)
		if [[ ${DISTUTILS_EXT} ]]; then
			packages+=(
				dev-python/cython
			)
		fi
		case ${DISTUTILS_USE_PEP517} in
			flit)
				packages+=(
					dev-python/flit-core
				)
				;;
			flit_scm)
				packages+=(
					dev-python/flit-core
					dev-python/flit_scm
					dev-python/setuptools-scm
				)
				;;
			hatchling)
				packages+=(
					dev-python/hatchling
					dev-python/hatch-fancy-pypi-readme
					dev-python/hatch-vcs
				)
				;;
			jupyter)
				packages+=(
					dev-python/jupyter-packaging
					dev-python/setuptools
					dev-python/setuptools-scm
					dev-python/wheel
				)
				;;
			maturin)
				packages+=(
					dev-util/maturin
				)
				;;
			no)
				return
				;;
			meson-python)
				packages+=(
					dev-python/meson-python
				)
				;;
			pbr)
				packages+=(
					dev-python/pbr
					dev-python/setuptools
					dev-python/wheel
				)
				;;
			pdm)
				packages+=(
					dev-python/pdm-pep517
					dev-python/setuptools
				)
				;;
			pdm-backend)
				packages+=(
					dev-python/pdm-backend
					dev-python/setuptools
				)
				;;
			poetry)
				packages+=(
					dev-python/poetry-core
				)
				;;
			scikit-build-core)
				packages+=(
					dev-python/scikit-build-core
				)
				;;
			setuptools)
				packages+=(
					dev-python/setuptools
					dev-python/setuptools-rust
					dev-python/setuptools-scm
					dev-python/wheel
				)
				;;
			sip)
				packages+=(
					dev-python/sip
				)
				;;
		esac
	else
		case ${DISTUTILS_USE_SETUPTOOLS} in
			manual|no)
				return
				;;
			*)
				packages+=(
					dev-python/setuptools
				)
				;;
		esac
	fi

	local pkg
	einfo "Build system packages:"
	for pkg in "${packages[@]}"; do
		local installed=$(best_version -b "${pkg}")
		einfo "  $(printf '%-30s' "${pkg}"): ${installed#${pkg}-}"
	done
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
	_distutils-r1_check_all_phase_mismatch

	if [[ ! ${DISTUTILS_OPTIONAL} ]]; then
		default
	fi

	# by default, use in-source build if python_prepare() is used
	if [[ ! ${DISTUTILS_IN_SOURCE_BUILD+1} ]]; then
		if declare -f python_prepare >/dev/null; then
			DISTUTILS_IN_SOURCE_BUILD=1
		fi
	fi

	if [[ ! ${DISTUTILS_USE_PEP517} ]]; then
		_distutils-r1_disable_ez_setup
		_distutils-r1_handle_pyproject_toml

		case ${DISTUTILS_USE_SETUPTOOLS} in
			no)
				eqawarn "Non-PEP517 builds are deprecated for ebuilds using plain distutils."
				eqawarn "Please migrate to DISTUTILS_USE_PEP517=setuptools."
				eqawarn "Please see Python Guide for more details:"
				eqawarn "  https://projects.gentoo.org/python/guide/distutils.html"
				;;
		esac
	fi

	if [[ ${DISTUTILS_IN_SOURCE_BUILD} && ! ${DISTUTILS_SINGLE_IMPL} ]]
	then
		# create source copies for each implementation
		python_copy_sources
	fi

	python_export_utf8_locale
	_distutils-r1_print_package_versions

	_DISTUTILS_DEFAULT_CALLED=1
}

# @FUNCTION: _distutils-r1_create_setup_cfg
# @INTERNAL
# @DESCRIPTION:
# Create implementation-specific configuration file for distutils,
# setting proper build-dir (and install-dir) paths.
_distutils-r1_create_setup_cfg() {
	if [[ ${DISTUTILS_USE_PEP517} ]]; then
		die "${FUNCNAME} is not implemented in PEP517 mode"
	fi

	cat > "${HOME}"/.pydistutils.cfg <<-_EOF_ || die
		[build]
		build_base = ${BUILD_DIR}

		# using a single directory for them helps us export
		# ${PYTHONPATH} and ebuilds find the sources independently
		# of whether the package installs extensions or not
		#
		# note: due to some packages (wxpython) relying on separate
		# platlib & purelib dirs, we do not set --build-lib (which
		# can not be overridden with --build-*lib)
		build_platlib = %(build_base)s/lib
		build_purelib = %(build_base)s/lib

		# make the ebuild writer lives easier
		build_scripts = %(build_base)s/scripts

		# this is needed by distutils_install_for_testing since
		# setuptools like to create .egg files for install --home.
		[bdist_egg]
		dist_dir = ${BUILD_DIR}/dist

		# avoid packing up eggs in a zip as it often breaks test suites
		[options]
		zip_safe = False
	_EOF_

	if [[ ${EBUILD_PHASE} == install ]]; then
		# we can't refer to ${D} before src_install()
		cat >> "${HOME}"/.pydistutils.cfg <<-_EOF_ || die

			# installation paths -- allow calling extra install targets
			# without the default 'install'
			[install]
			compile = True
			optimize = 2
			root = ${D%/}
		_EOF_

		if [[ ! ${DISTUTILS_SINGLE_IMPL} ]]; then
			# this gets appended to [install]
			cat >> "${HOME}"/.pydistutils.cfg <<-_EOF_ || die
				install_scripts = $(python_get_scriptdir)
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
	if [[ ${DISTUTILS_USE_PEP517} ]]; then
		die "${FUNCNAME} is not implemented in PEP517 mode"
	fi

	mkdir -p "${BUILD_DIR}" || die
	# stupid freebsd can't do 'cp -t ${BUILD_DIR} {} +'
	find -name '*.egg-info' -type d -exec cp -R -p {} "${BUILD_DIR}"/ ';' || die
}

# @FUNCTION: _distutils-r1_backend_to_key
# @USAGE: <backend>
# @INTERNAL
# @DESCRIPTION:
# Print the DISTUTILS_USE_PEP517 value corresponding to the backend
# passed as the only argument.
_distutils-r1_backend_to_key() {
	debug-print-function ${FUNCNAME} "${@}"

	local backend=${1}
	case ${backend} in
		flit_core.buildapi|flit.buildapi)
			echo flit
			;;
		flit_scm:buildapi)
			echo flit_scm
			;;
		hatchling.build)
			echo hatchling
			;;
		jupyter_packaging.build_api)
			echo jupyter
			;;
		maturin)
			echo maturin
			;;
		mesonpy)
			echo meson-python
			;;
		pbr.build)
			echo pbr
			;;
		pdm.backend)
			echo pdm-backend
			;;
		pdm.pep517.api)
			echo pdm
			;;
		poetry.core.masonry.api|poetry.masonry.api)
			echo poetry
			;;
		scikit_build_core.build)
			echo scikit-build-core
			;;
		setuptools.build_meta|setuptools.build_meta:__legacy__)
			echo setuptools
			;;
		sipbuild.api)
			echo sip
			;;
		*)
			die "Unknown backend: ${backend}"
			;;
	esac
}

# @FUNCTION: _distutils-r1_get_backend
# @INTERNAL
# @DESCRIPTION:
# Read (or guess, in case of setuptools) the build-backend
# for the package in the current directory.
_distutils-r1_get_backend() {
	debug-print-function ${FUNCNAME} "${@}"

	local build_backend legacy_fallback
	if [[ -f pyproject.toml ]]; then
		# if pyproject.toml exists, try getting the backend from it
		# NB: this could fail if pyproject.toml doesn't list one
		build_backend=$(gpep517 get-backend)
	fi
	if [[ -z ${build_backend} && ${DISTUTILS_USE_PEP517} == setuptools &&
		-f setup.py ]]
	then
		# use the legacy setuptools backend as a fallback
		build_backend=setuptools.build_meta:__legacy__
		legacy_fallback=1
	fi
	if [[ -z ${build_backend} ]]; then
		die "Unable to obtain build-backend from pyproject.toml"
	fi

	if [[ ${DISTUTILS_USE_PEP517} != standalone ]]; then
		# verify whether DISTUTILS_USE_PEP517 was set correctly
		local expected_value=$(_distutils-r1_backend_to_key "${build_backend}")
		if [[ ${DISTUTILS_USE_PEP517} != ${expected_value} ]]; then
			eerror "DISTUTILS_USE_PEP517 does not match pyproject.toml!"
			eerror "    have: DISTUTILS_USE_PEP517=${DISTUTILS_USE_PEP517}"
			eerror "expected: DISTUTILS_USE_PEP517=${expected_value}"
			eerror "(backend: ${build_backend})"
			die "DISTUTILS_USE_PEP517 value incorrect"
		fi

		# fix deprecated backends up
		local new_backend=
		case ${build_backend} in
			flit.buildapi)
				new_backend=flit_core.buildapi
				;;
			poetry.masonry.api)
				new_backend=poetry.core.masonry.api
				;;
			setuptools.build_meta:__legacy__)
				# this backend should only be used as implicit fallback
				[[ ! ${legacy_fallback} ]] &&
					new_backend=setuptools.build_meta
				;;
		esac

		if [[ -n ${new_backend} ]]; then
			if [[ ! -f ${T}/.distutils_deprecated_backend_warned ]]; then
				eqawarn "${build_backend} backend is deprecated.  Please see:"
				eqawarn "https://projects.gentoo.org/python/guide/qawarn.html#deprecated-pep-517-backends"
				eqawarn "The eclass will be using ${new_backend} instead."
				> "${T}"/.distutils_deprecated_backend_warned || die
			fi
			build_backend=${new_backend}
		fi
	fi

	echo "${build_backend}"
}

# @FUNCTION: distutils_wheel_install
# @USAGE: <root> <wheel>
# @DESCRIPTION:
# Install the specified wheel into <root>.
#
# This function is intended for expert use only.
distutils_wheel_install() {
	debug-print-function ${FUNCNAME} "${@}"
	if [[ ${#} -ne 2 ]]; then
		die "${FUNCNAME} takes exactly two arguments: <root> <wheel>"
	fi
	if [[ -z ${PYTHON} ]]; then
		die "PYTHON unset, invalid call context"
	fi

	local root=${1}
	local wheel=${2}

	einfo "  Installing ${wheel##*/} to ${root}"
	local cmd=(
		gpep517 install-wheel
			--destdir="${root}"
			--interpreter="${PYTHON}"
			--prefix="${EPREFIX}/usr"
			--optimize=all
			"${wheel}"
	)
	printf '%s\n' "${cmd[*]}"
	"${cmd[@]}" || die "Wheel install failed"

	# remove installed licenses
	find "${root}$(python_get_sitedir)" -depth \
		\( -path '*.dist-info/COPYING*' \
		-o -path '*.dist-info/LICENSE*' \
		-o -path '*.dist-info/license_files/*' \
		-o -path '*.dist-info/license_files' \
		-o -path '*.dist-info/licenses/*' \
		-o -path '*.dist-info/licenses' \
		\) -delete || die
}

# @FUNCTION: distutils_pep517_install
# @USAGE: <root>
# @DESCRIPTION:
# Build the wheel for the package in the current directory using PEP 517
# backend and install it into <root>.
#
# This function is intended for expert use only.  It does not handle
# wrapping executables.
distutils_pep517_install() {
	debug-print-function ${FUNCNAME} "${@}"
	[[ ${#} -eq 1 ]] || die "${FUNCNAME} takes exactly one argument: root"

	if [[ ! ${DISTUTILS_USE_PEP517:-no} != no ]]; then
		die "${FUNCNAME} is available only in PEP517 mode"
	fi

	local root=${1}
	export BUILD_DIR
	local -x WHEEL_BUILD_DIR=${BUILD_DIR}/wheel
	mkdir -p "${WHEEL_BUILD_DIR}" || die

	if [[ -n ${mydistutilsargs[@]} ]]; then
		die "mydistutilsargs are banned in PEP517 mode (use DISTUTILS_ARGS)"
	fi

	local config_settings=
	case ${DISTUTILS_USE_PEP517} in
		maturin)
			# `maturin pep517 build-wheel --help` for options
			local maturin_args=(
				"${DISTUTILS_ARGS[@]}"
				--jobs="$(makeopts_jobs)"
				--skip-auditwheel # see bug #831171
				$(in_iuse debug && usex debug '--profile=dev' '')
			)

			config_settings=$(
				"${EPYTHON}" - "${maturin_args[@]}" <<-EOF || die
					import json
					import sys
					print(json.dumps({"build-args": sys.argv[1:]}))
				EOF
			)
			;;
		meson-python)
			local -x NINJAOPTS=$(get_NINJAOPTS)
			config_settings=$(
				"${EPYTHON}" - "${DISTUTILS_ARGS[@]}" <<-EOF || die
					import json
					import os
					import shlex
					import sys

					ninjaopts = shlex.split(os.environ["NINJAOPTS"])
					print(json.dumps({
						"builddir": "${BUILD_DIR}",
						"setup-args": sys.argv[1:],
						"compile-args": ["-v"] + ninjaopts,
					}))
				EOF
			)
			;;
		setuptools)
			if [[ -n ${DISTUTILS_ARGS[@]} ]]; then
				config_settings=$(
					"${EPYTHON}" - "${DISTUTILS_ARGS[@]}" <<-EOF || die
						import json
						import sys
						print(json.dumps({"--build-option": sys.argv[1:]}))
					EOF
				)
			fi
			;;
		sip)
			if [[ -n ${DISTUTILS_ARGS[@]} ]]; then
				# NB: for practical reasons, we support only --foo=bar,
				# not --foo bar
				local arg
				for arg in "${DISTUTILS_ARGS[@]}"; do
					[[ ${arg} != -* ]] &&
						die "Bare arguments in DISTUTILS_ARGS unsupported: ${arg}"
				done

				config_settings=$(
					"${EPYTHON}" - "${DISTUTILS_ARGS[@]}" <<-EOF || die
						import collections
						import json
						import sys

						args = collections.defaultdict(list)
						for arg in (x.split("=", 1) for x in sys.argv[1:]): \
							args[arg[0]].extend(
								[arg[1]] if len(arg) > 1 else [])

						print(json.dumps(args))
					EOF
				)
			fi
			;;
		*)
			[[ -n ${DISTUTILS_ARGS[@]} ]] &&
				die "DISTUTILS_ARGS are not supported by ${DISTUTILS_USE_PEP517}"
			;;
	esac

	local build_backend=$(_distutils-r1_get_backend)
	einfo "  Building the wheel for ${PWD#${WORKDIR}/} via ${build_backend}"
	local cmd=(
		gpep517 build-wheel
			--backend "${build_backend}"
			--output-fd 3
			--wheel-dir "${WHEEL_BUILD_DIR}"
	)
	if [[ -n ${config_settings} ]]; then
		cmd+=( --config-json "${config_settings}" )
	fi
	if [[ -n ${SYSROOT} ]]; then
		cmd+=( --sysroot "${SYSROOT}" )
	fi
	printf '%s\n' "${cmd[*]}"
	local wheel=$(
		"${cmd[@]}" 3>&1 >&2 || die "Wheel build failed"
	)
	[[ -n ${wheel} ]] || die "No wheel name returned"

	distutils_wheel_install "${root}" "${WHEEL_BUILD_DIR}/${wheel}"

	# clean the build tree; otherwise we may end up with PyPy3
	# extensions duplicated into CPython dists
	if [[ ${DISTUTILS_USE_PEP517:-setuptools} == setuptools ]]; then
		rm -rf build || die
	fi
}

# @FUNCTION: distutils-r1_python_compile
# @USAGE: [additional-args...]
# @DESCRIPTION:
# The default python_compile().
#
# If DISTUTILS_USE_PEP517 is set to "no", a no-op.
#
# If DISTUTILS_USE_PEP517 is set to any other value, builds a wheel
# using the PEP517 backend and installs it into ${BUILD_DIR}/install.
# May additionally call build_ext prior to that when using setuptools
# and the eclass detects a potential benefit from parallel extension
# builds.
#
# In legacy mode, runs 'esetup.py build'. Any parameters passed to this
# function will be appended to setup.py invocation, i.e. passed
# as options to the 'build' command.
distutils-r1_python_compile() {
	debug-print-function ${FUNCNAME} "${@}"

	_python_check_EPYTHON

	case ${DISTUTILS_USE_PEP517:-setuptools} in
		setuptools)
			# call setup.py build when using setuptools (either via PEP517
			# or in legacy mode)

			if [[ ${DISTUTILS_USE_PEP517} ]]; then
				if [[ -d build ]]; then
					eqawarn "A 'build' directory exists already.  Artifacts from this directory may"
					eqawarn "be picked up by setuptools when building for another interpreter."
					eqawarn "Please remove this directory prior to building."
				fi
			else
				_distutils-r1_copy_egg_info
			fi

			# distutils is parallel-capable since py3.5
			local jobs=$(makeopts_jobs "${MAKEOPTS} ${*}")

			if [[ ${DISTUTILS_USE_PEP517} ]]; then
				# issue build_ext only if it looks like we have at least
				# two source files to build; setuptools is expensive
				# to start and parallel builds can only benefit us if we're
				# compiling at least two files
				#
				# see extension.py for list of suffixes
				# .pyx is added for Cython
				#
				# esetup.py does not respect SYSROOT, so skip it there
				if [[ -z ${SYSROOT} && ${DISTUTILS_EXT} && 1 -ne ${jobs}
					&& 2 -eq $(
						find '(' -name '*.c' -o -name '*.cc' -o -name '*.cpp' \
							-o -name '*.cxx' -o -name '*.c++' -o -name '*.m' \
							-o -name '*.mm' -o -name '*.pyx' ')' -printf '\n' |
							head -n 2 | wc -l
					)
				]]; then
					esetup.py build_ext -j "${jobs}" "${@}"
				fi
			else
				esetup.py build -j "${jobs}" "${@}"
			fi
			;;
		no)
			return
			;;
	esac

	if [[ ${DISTUTILS_USE_PEP517} ]]; then
		distutils_pep517_install "${BUILD_DIR}/install"
	fi
}

# @FUNCTION: _distutils-r1_wrap_scripts
# @USAGE: <bindir>
# @INTERNAL
# @DESCRIPTION:
# Moves and wraps all installed scripts/executables as necessary.
_distutils-r1_wrap_scripts() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${#} -eq 1 ]] || die "usage: ${FUNCNAME} <bindir>"
	local bindir=${1}

	local scriptdir=$(python_get_scriptdir)
	local f python_files=() non_python_files=()

	if [[ -d ${D%/}${scriptdir} ]]; then
		for f in "${D%/}${scriptdir}"/*; do
			[[ -d ${f} ]] && die "Unexpected directory: ${f}"
			debug-print "${FUNCNAME}: found executable at ${f#${D%/}/}"

			local shebang
			read -r shebang < "${f}"
			if [[ ${shebang} == '#!'*${EPYTHON}* ]]; then
				debug-print "${FUNCNAME}: matching shebang: ${shebang}"
				python_files+=( "${f}" )
			else
				debug-print "${FUNCNAME}: non-matching shebang: ${shebang}"
				non_python_files+=( "${f}" )
			fi

			mkdir -p "${D%/}${bindir}" || die
		done

		for f in "${python_files[@]}"; do
			local basename=${f##*/}

			debug-print "${FUNCNAME}: installing wrapper at ${bindir}/${basename}"
			local dosym=dosym
			[[ ${EAPI} == 7 ]] && dosym=dosym8
			"${dosym}" -r /usr/lib/python-exec/python-exec2 \
				"${bindir#${EPREFIX}}/${basename}"
		done

		for f in "${non_python_files[@]}"; do
			local basename=${f##*/}

			debug-print "${FUNCNAME}: moving ${f#${D%/}/} to ${bindir}/${basename}"
			mv "${f}" "${D%/}${bindir}/${basename}" || die
		done
	fi
}

# @FUNCTION: distutils-r1_python_test
# @USAGE: [additional-args...]
# @DESCRIPTION:
# The python_test() implementation used by distutils_enable_tests.
# Runs tests using the specified test runner, possibly installing them
# first.
#
# This function is used only if distutils_enable_tests is called.
distutils-r1_python_test() {
	debug-print-function ${FUNCNAME} "${@}"

	if [[ -z ${_DISTUTILS_TEST_RUNNER} ]]; then
		die "${FUNCNAME} can be only used after calling distutils_enable_tests"
	fi

	_python_check_EPYTHON

	if [[ ${_DISTUTILS_TEST_INSTALL} ]]; then
		distutils_install_for_testing
	fi

	case ${_DISTUTILS_TEST_RUNNER} in
		nose)
			"${EPYTHON}" -m nose -v "${@}"
			;;
		pytest)
			epytest
			;;
		setup.py)
			nonfatal esetup.py test --verbose
			;;
		unittest)
			eunittest
			;;
		*)
			die "Mis-synced test runner between ${FUNCNAME} and distutils_enable_testing"
			;;
	esac

	if [[ ${?} -ne 0 ]]; then
		die -n "Tests failed with ${EPYTHON}"
	fi
}

# @FUNCTION: distutils-r1_python_install
# @USAGE: [additional-args...]
# @DESCRIPTION:
# The default python_install().
#
# In PEP517 mode, merges the files from ${BUILD_DIR}/install
# (if present) to the image directory.
#
# In the legacy mode, calls `esetup.py install` to install the package.
# Any parameters passed to this function will be appended
# to the setup.py invocation (i.e. as options to the 'install' command).
distutils-r1_python_install() {
	debug-print-function ${FUNCNAME} "${@}"

	_python_check_EPYTHON

	local scriptdir=${EPREFIX}/usr/bin
	local merge_root=
	if [[ ${DISTUTILS_USE_PEP517} ]]; then
		local root=${BUILD_DIR}/install
		local reg_scriptdir=${root}/${scriptdir}
		local wrapped_scriptdir=${root}$(python_get_scriptdir)

		# we are assuming that _distutils-r1_post_python_compile
		# has been called and ${root} has not been altered since
		# let's explicitly verify these assumptions

		# remove files that we've created explicitly
		rm "${reg_scriptdir}"/{"${EPYTHON}",python3,python,pyvenv.cfg} || die

		# Automagically do the QA check to avoid issues when bootstrapping
		# prefix.
		if type diff &>/dev/null ; then
			# verify that scriptdir & wrapped_scriptdir both contain
			# the same files
			(
				cd "${reg_scriptdir}" && find . -mindepth 1
			) | sort > "${T}"/.distutils-files-bin
			assert "listing ${reg_scriptdir} failed"
			(
				if [[ -d ${wrapped_scriptdir} ]]; then
					cd "${wrapped_scriptdir}" && find . -mindepth 1
				fi
			) | sort > "${T}"/.distutils-files-wrapped
			assert "listing ${wrapped_scriptdir} failed"
			if ! diff -U 0 "${T}"/.distutils-files-{bin,wrapped}; then
				die "File lists for ${reg_scriptdir} and ${wrapped_scriptdir} differ (see diff above)"
			fi
		fi

		# remove the altered bindir, executables from the package
		# are already in scriptdir
		rm -r "${reg_scriptdir}" || die
		if [[ ${DISTUTILS_SINGLE_IMPL} ]]; then
			if [[ -d ${wrapped_scriptdir} ]]; then
				mv "${wrapped_scriptdir}" "${reg_scriptdir}" || die
			fi
		fi
		# prune empty directories to see if ${root} contains anything
		# to merge
		find "${BUILD_DIR}"/install -type d -empty -delete || die
		[[ -d ${BUILD_DIR}/install ]] && merge_root=1
	else
		local root=${D%/}/_${EPYTHON}
		[[ ${DISTUTILS_SINGLE_IMPL} ]] && root=${D%/}

		# inline DISTUTILS_ARGS logic from esetup.py in order to make
		# argv overwriting easier
		local args=(
			"${DISTUTILS_ARGS[@]}"
			"${mydistutilsargs[@]}"
			install --skip-build --root="${root}" "${args[@]}"
			"${@}"
		)
		local DISTUTILS_ARGS=()
		local mydistutilsargs=()

		# enable compilation for the install phase.
		local -x PYTHONDONTWRITEBYTECODE=

		# python likes to compile any module it sees, which triggers sandbox
		# failures if some packages haven't compiled their modules yet.
		addpredict "${EPREFIX}/usr/lib/${EPYTHON}"
		addpredict "${EPREFIX}/usr/lib/pypy3.10"
		addpredict "${EPREFIX}/usr/local" # bug 498232

		if [[ ! ${DISTUTILS_SINGLE_IMPL} ]]; then
			merge_root=1

			# user may override --install-scripts
			# note: this is poor but distutils argv parsing is dumb

			# rewrite all the arguments
			set -- "${args[@]}"
			args=()
			while [[ ${@} ]]; do
				local a=${1}
				shift

				case ${a} in
					--install-scripts=*)
						scriptdir=${a#--install-scripts=}
						;;
					--install-scripts)
						scriptdir=${1}
						shift
						;;
					*)
						args+=( "${a}" )
						;;
				esac
			done
		fi

		esetup.py "${args[@]}"
	fi

	if [[ ${merge_root} ]]; then
		multibuild_merge_root "${root}" "${D%/}"
	fi
	if [[ ! ${DISTUTILS_SINGLE_IMPL} ]]; then
		_distutils-r1_wrap_scripts "${scriptdir}"
	fi
}

# @FUNCTION: distutils-r1_python_install_all
# @DESCRIPTION:
# The default python_install_all(). It installs the documentation.
distutils-r1_python_install_all() {
	debug-print-function ${FUNCNAME} "${@}"
	_distutils-r1_check_all_phase_mismatch

	einstalldocs
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
		[[ ${DISTUTILS_USE_PEP517} ]] &&
			die "DISTUTILS_IN_SOURCE_BUILD is not supported in PEP517 mode"
		# only force BUILD_DIR if implementation is explicitly enabled
		# for building; any-r1 API may select one that is not
		# https://bugs.gentoo.org/701506
		if [[ ! ${DISTUTILS_SINGLE_IMPL} ]] &&
				has "${EPYTHON/./_}" ${PYTHON_TARGETS}; then
			cd "${BUILD_DIR}" || die
		fi
		local BUILD_DIR=${BUILD_DIR}/build
	fi

	if [[ ${DISTUTILS_USE_PEP517} ]]; then
		local -x PATH=${BUILD_DIR}/install${EPREFIX}/usr/bin:${PATH}
	else
		local -x PYTHONPATH="${BUILD_DIR}/lib:${PYTHONPATH}"

		# make PATH local for distutils_install_for_testing calls
		# it makes little sense to let user modify PATH in per-impl phases
		# and _all() already localizes it
		local -x PATH=${PATH}

		if _python_impl_matches "${EPYTHON}" 3.{9..11}; then
			# Undo the default switch in setuptools-60+ for the time being,
			# to avoid replacing .egg-info file with directory in-place.
			local -x SETUPTOOLS_USE_DISTUTILS="${SETUPTOOLS_USE_DISTUTILS:-stdlib}"
		fi

		# Bug 559644
		# using PYTHONPATH when the ${BUILD_DIR}/lib is not created yet might lead to
		# problems in setup.py scripts that try to import modules/packages from that path
		# during the build process (Python at startup evaluates PYTHONPATH, if the dir is
		# not valid then associates a NullImporter object to ${BUILD_DIR}/lib storing it
		# in the sys.path_importer_cache)
		mkdir -p "${BUILD_DIR}/lib" || die
	fi

	# Set up build environment, bug #513664.
	local -x AR=${AR} CC=${CC} CPP=${CPP} CXX=${CXX}
	tc-export AR CC CPP CXX

	if [[ ${DISTUTILS_EXT} ]]; then
		local -x CPPFLAGS="${CPPFLAGS} $(usex debug '-UNDEBUG' '-DNDEBUG')"
		# always generate .c files from .pyx files to ensure we get latest
		# bug fixes from Cython (this works only when setup.py is using
		# cythonize() but it's better than nothing)
		local -x CYTHON_FORCE_REGEN=1
	fi

	# Rust extensions are incompatible with C/C++ LTO compiler
	# see e.g. https://bugs.gentoo.org/910220
	if has cargo ${INHERITED}; then
		filter-lto
	fi

	# How to build Python modules in different worlds...
	local ldopts
	case "${CHOST}" in
		# provided by grobian, 2014-06-22, bug #513664 c7
		*-darwin*) ldopts='-bundle -undefined dynamic_lookup';;
		*) ldopts='-shared';;
	esac

	local -x LDSHARED="${CC} ${ldopts}" LDCXXSHARED="${CXX} ${ldopts}"
	local _DISTUTILS_POST_PHASE_RM=()

	"${@}"
	local ret=${?}

	if [[ -n ${_DISTUTILS_POST_PHASE_RM} ]]; then
		rm "${_DISTUTILS_POST_PHASE_RM[@]}" || die
	fi

	cd "${_DISTUTILS_INITIAL_CWD}" || die
	if [[ ! ${_DISTUTILS_IN_COMMON_IMPL} ]] &&
		declare -f "_distutils-r1_post_python_${EBUILD_PHASE}" >/dev/null
	then
		"_distutils-r1_post_python_${EBUILD_PHASE}"
	fi
	return "${ret}"
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
	local _DISTUTILS_IN_COMMON_IMPL=1

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
		local _DISTUTILS_CALLING_FOREACH_IMPL=1
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
	local ret=0
	local _DISTUTILS_DEFAULT_CALLED

	# common preparations
	if declare -f python_prepare_all >/dev/null; then
		python_prepare_all || ret=${?}
	else
		distutils-r1_python_prepare_all || ret=${?}
	fi

	if [[ ! ${_DISTUTILS_DEFAULT_CALLED} ]]; then
		die "QA: python_prepare_all() didn't call distutils-r1_python_prepare_all"
	fi

	if declare -f python_prepare >/dev/null; then
		_distutils-r1_run_foreach_impl python_prepare || ret=${?}
	fi

	return ${ret}
}

distutils-r1_src_configure() {
	debug-print-function ${FUNCNAME} "${@}"
	local ret=0

	if declare -f python_configure >/dev/null; then
		_distutils-r1_run_foreach_impl python_configure || ret=${?}
	fi

	if declare -f python_configure_all >/dev/null; then
		_distutils-r1_run_common_phase python_configure_all || ret=${?}
	fi

	return ${ret}
}

# @FUNCTION: _distutils-r1_post_python_compile
# @INTERNAL
# @DESCRIPTION:
# Post-phase function called after python_compile.  In PEP517 mode,
# it adjusts the install tree for venv-style usage.
_distutils-r1_post_python_compile() {
	debug-print-function ${FUNCNAME} "${@}"

	local root=${BUILD_DIR}/install
	if [[ ${DISTUTILS_USE_PEP517} && -d ${root} ]]; then
		# copy executables to python-exec directory
		# we do it early so that we can alter bindir recklessly
		local bindir=${root}${EPREFIX}/usr/bin
		local rscriptdir=${root}$(python_get_scriptdir)
		[[ -d ${rscriptdir} ]] &&
			die "${rscriptdir} should not exist!"
		if [[ -d ${bindir} ]]; then
			mkdir -p "${rscriptdir}" || die
			cp -a "${bindir}"/. "${rscriptdir}"/ || die
		fi

		# enable venv magic inside the install tree
		mkdir -p "${bindir}" || die
		ln -s "${PYTHON}" "${bindir}/${EPYTHON}" || die
		ln -s "${EPYTHON}" "${bindir}/python3" || die
		ln -s "${EPYTHON}" "${bindir}/python" || die
		cat > "${bindir}"/pyvenv.cfg <<-EOF || die
			include-system-site-packages = true
		EOF

		# we need to change shebangs to point to the venv-python
		find "${bindir}" -type f -exec sed -i \
			-e "1s@^#!\(${EPREFIX}/usr/bin/\(python\|pypy\)\)@#!${root}\1@" \
			{} + || die
	fi
}

distutils-r1_src_compile() {
	debug-print-function ${FUNCNAME} "${@}"
	local ret=0

	if declare -f python_compile >/dev/null; then
		_distutils-r1_run_foreach_impl python_compile || ret=${?}
	else
		_distutils-r1_run_foreach_impl distutils-r1_python_compile || ret=${?}
	fi

	if declare -f python_compile_all >/dev/null; then
		_distutils-r1_run_common_phase python_compile_all || ret=${?}
	fi

	return ${ret}
}

# @FUNCTION: _distutils-r1_clean_egg_info
# @INTERNAL
# @DESCRIPTION:
# Clean up potential stray egg-info files left by setuptools test phase.
# Those files ended up being unversioned, and caused issues:
# https://bugs.gentoo.org/534058
_distutils-r1_clean_egg_info() {
	if [[ ${DISTUTILS_USE_PEP517} ]]; then
		die "${FUNCNAME} is not implemented in PEP517 mode"
	fi

	rm -rf "${BUILD_DIR}"/lib/*.egg-info || die
}

# @FUNCTION: _distutils-r1_post_python_test
# @INTERNAL
# @DESCRIPTION:
# Post-phase function called after python_test.
_distutils-r1_post_python_test() {
	debug-print-function ${FUNCNAME} "${@}"

	if [[ ! ${DISTUTILS_USE_PEP517} ]]; then
		_distutils-r1_clean_egg_info
	fi
}

distutils-r1_src_test() {
	debug-print-function ${FUNCNAME} "${@}"
	local ret=0

	if declare -f python_test >/dev/null; then
		_distutils-r1_run_foreach_impl python_test || ret=${?}
	fi

	if declare -f python_test_all >/dev/null; then
		_distutils-r1_run_common_phase python_test_all || ret=${?}
	fi

	return ${ret}
}

# @FUNCTION: _distutils-r1_strip_namespace_packages
# @USAGE: <sitedir>
# @INTERNAL
# @DESCRIPTION:
# Find and remove setuptools-style namespaces in the specified
# directory.
_distutils-r1_strip_namespace_packages() {
	debug-print-function ${FUNCNAME} "${@}"

	local sitedir=${1}
	local f ns had_any=
	while IFS= read -r -d '' f; do
		while read -r ns; do
			einfo "Stripping pkg_resources-style namespace ${ns}"
			had_any=1
		done < "${f}"

		rm "${f}" || die
	done < <(
		# NB: this deliberately does not include .egg-info, in order
		# to limit this to PEP517 mode.
		find "${sitedir}" -path '*.dist-info/namespace_packages.txt' -print0
	)

	# If we had any namespace packages, remove .pth files as well.
	if [[ ${had_any} ]]; then
		find "${sitedir}" -name '*-nspkg.pth' -delete || die
	fi
}

# @FUNCTION: _distutils-r1_post_python_install
# @INTERNAL
# @DESCRIPTION:
# Post-phase function called after python_install.  Performs QA checks.
# In PEP517 mode, additionally optimizes installed Python modules.
_distutils-r1_post_python_install() {
	debug-print-function ${FUNCNAME} "${@}"

	local sitedir=${D%/}$(python_get_sitedir)
	if [[ -d ${sitedir} ]]; then
		_distutils-r1_strip_namespace_packages "${sitedir}"

		local forbidden_package_names=(
			examples test tests
			.pytest_cache .hypothesis _trial_temp
		)
		local strays=()
		local p
		mapfile -d $'\0' -t strays < <(
			find "${sitedir}" -maxdepth 1 -type f '!' '(' \
					-name '*.egg-info' -o \
					-name '*.pth' -o \
					-name '*.py' -o \
					-name '*.pyi' -o \
					-name "*$(get_modname)" \
				')' -print0
		)
		for p in "${forbidden_package_names[@]}"; do
			[[ -d ${sitedir}/${p} ]] && strays+=( "${sitedir}/${p}" )
		done

		if [[ -n ${strays[@]} ]]; then
			eerror "The following unexpected files/directories were found top-level"
			eerror "in the site-packages directory:"
			eerror
			for p in "${strays[@]}"; do
				eerror "  ${p#${ED}}"
			done
			eerror
			eerror "This is most likely a bug in the build system.  More information"
			eerror "can be found in the Python Guide:"
			eerror "https://projects.gentoo.org/python/guide/qawarn.html#stray-top-level-files-in-site-packages"
			die "Failing install because of stray top-level files in site-packages"
		fi

		if [[ ! ${DISTUTILS_EXT} && ! ${_DISTUTILS_EXT_WARNED} ]]; then
			if [[ $(find "${sitedir}" -name "*$(get_modname)" | head -n 1) ]]
			then
				eqawarn "Python extension modules (*$(get_modname)) found installed. Please set:"
				eqawarn "  DISTUTILS_EXT=1"
				eqawarn "in the ebuild."
				_DISTUTILS_EXT_WARNED=1
			fi
		fi
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
		eerror "The following *-nspkg.pth files were found installed:"
		eerror
		for f in "${pth[@]}"; do
			eerror "  ${f#${ED%/}}"
		done
		eerror
		eerror "The presence of those files may break namespaces in Python 3.5+. Please"
		eerror "read our documentation on reliable handling of namespaces and update"
		eerror "the ebuild accordingly:"
		eerror
		eerror "  https://projects.gentoo.org/python/guide/concept.html#namespace-packages"

		die "Installing *-nspkg.pth files is banned"
	fi
}

distutils-r1_src_install() {
	debug-print-function ${FUNCNAME} "${@}"
	local ret=0

	if declare -f python_install >/dev/null; then
		_distutils-r1_run_foreach_impl python_install || ret=${?}
	else
		_distutils-r1_run_foreach_impl distutils-r1_python_install || ret=${?}
	fi

	if declare -f python_install_all >/dev/null; then
		_distutils-r1_run_common_phase python_install_all || ret=${?}
	else
		_distutils-r1_run_common_phase distutils-r1_python_install_all || ret=${?}
	fi

	_distutils-r1_check_namespace_pth

	return ${ret}
}

fi

if [[ ! ${DISTUTILS_OPTIONAL} ]]; then
	EXPORT_FUNCTIONS src_prepare src_configure src_compile src_test src_install
fi
