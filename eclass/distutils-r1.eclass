# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/distutils-r1.eclass,v 1.115 2015/07/16 14:29:39 mgorny Exp $

# @ECLASS: distutils-r1
# @MAINTAINER:
# Python team <python@gentoo.org>
# @AUTHOR:
# Author: Michał Górny <mgorny@gentoo.org>
# Based on the work of: Krzysztof Pawlik <nelchael@gentoo.org>
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
# For more information, please see the wiki:
# https://wiki.gentoo.org/wiki/Project:Python/distutils-r1

case "${EAPI:-0}" in
	0|1|2|3)
		die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}"
		;;
	4|5)
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

if [[ ! ${_DISTUTILS_R1} ]]; then

inherit eutils toolchain-funcs

if [[ ! ${DISTUTILS_SINGLE_IMPL} ]]; then
	inherit multiprocessing python-r1
else
	inherit python-single-r1
fi

fi

if [[ ! ${DISTUTILS_OPTIONAL} ]]; then
	EXPORT_FUNCTIONS src_prepare src_configure src_compile src_test src_install
fi

if [[ ! ${_DISTUTILS_R1} ]]; then

if [[ ! ${DISTUTILS_OPTIONAL} ]]; then
	RDEPEND=${PYTHON_DEPS}
	DEPEND=${PYTHON_DEPS}
	REQUIRED_USE=${PYTHON_REQUIRED_USE}
fi

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

# @FUNCTION: esetup.py
# @USAGE: [<args>...]
# @DESCRIPTION:
# Run setup.py using currently selected Python interpreter
# (if ${PYTHON} is set; fallback 'python' otherwise).
#
# setup.py will be passed the following, in order:
# 1. ${mydistutilsargs[@]}
# 2. additional arguments passed to the esetup.py function.
#
# Please note that setup.py will respect defaults (unless overriden
# via command-line options) from setup.cfg that is created
# in distutils-r1_python_compile and in distutils-r1_python_install.
#
# This command dies on failure.
esetup.py() {
	debug-print-function ${FUNCNAME} "${@}"

	set -- "${PYTHON:-python}" setup.py "${mydistutilsargs[@]}" "${@}"

	echo "${@}" >&2
	"${@}" || die
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

	[[ ${PATCHES} ]] && epatch "${PATCHES[@]}"

	epatch_user

	# by default, use in-source build if python_prepare() is used
	if [[ ! ${DISTUTILS_IN_SOURCE_BUILD+1} ]]; then
		if declare -f python_prepare >/dev/null; then
			DISTUTILS_IN_SOURCE_BUILD=1
		fi
	fi

	_distutils-r1_disable_ez_setup

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

	:
}

# @FUNCTION: distutils-r1_python_configure
# @DESCRIPTION:
# The default python_configure(). A no-op.
distutils-r1_python_configure() {
	debug-print-function ${FUNCNAME} "${@}"

	:
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
		# can not be overriden with --build-*lib)
		build-platlib = %(build-base)s/lib
		build-purelib = %(build-base)s/lib

		# make the ebuild writer lives easier
		build-scripts = %(build-base)s/scripts

		[egg_info]
		egg-base = ${BUILD_DIR}

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
			root = ${D}
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
	find -name '*.egg-info' -type d -exec cp -pr {} "${BUILD_DIR}"/ ';' || die
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

	_distutils-r1_create_setup_cfg
	_distutils-r1_copy_egg_info

	esetup.py build "${@}"
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

	local PYTHON_SCRIPTDIR
	python_export PYTHON_SCRIPTDIR

	local f python_files=() non_python_files=()

	if [[ -d ${path}${PYTHON_SCRIPTDIR} ]]; then
		for f in "${path}${PYTHON_SCRIPTDIR}"/*; do
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

	# re-create setup.cfg with install paths
	_distutils-r1_create_setup_cfg

	# python likes to compile any module it sees, which triggers sandbox
	# failures if some packages haven't compiled their modules yet.
	addpredict "$(python_get_sitedir)"
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

	local root=${D}/_${EPYTHON}
	[[ ${DISTUTILS_SINGLE_IMPL} ]] && root=${D}

	esetup.py install --root="${root}" "${args[@]}"

	local forbidden_package_names=( examples test tests )
	local p
	for p in "${forbidden_package_names[@]}"; do
		if [[ -d ${root}$(python_get_sitedir)/${p} ]]; then
			die "Package installs '${p}' package which is forbidden and likely a bug in the build system."
		fi
	done
	if [[ -d ${root}/usr/$(get_libdir)/pypy/share ]]; then
		eqawarn "Package installs 'share' in PyPy prefix, see bug #465546."
	fi

	if [[ ! ${DISTUTILS_SINGLE_IMPL} ]]; then
		_distutils-r1_wrap_scripts "${root}" "${scriptdir}"
		multibuild_merge_root "${root}" "${D}"
	fi
}

# @FUNCTION: distutils-r1_python_install_all
# @DESCRIPTION:
# The default python_install_all(). It installs the documentation.
distutils-r1_python_install_all() {
	debug-print-function ${FUNCNAME} "${@}"

	einstalldocs

	if declare -p EXAMPLES &>/dev/null; then
		local INSDESTTREE=/usr/share/doc/${PF}/examples
		doins -r "${EXAMPLES[@]}"
		docompress -x "${INSDESTTREE}"
	fi

	_DISTUTILS_DEFAULT_CALLED=1
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
		if [[ ! ${DISTUTILS_SINGLE_IMPL} ]]; then
			cd "${BUILD_DIR}" || die
		fi
		local BUILD_DIR=${BUILD_DIR}/build
	fi
	local -x PYTHONPATH="${BUILD_DIR}/lib:${PYTHONPATH}"

	# We need separate home for each implementation, for .pydistutils.cfg.
	if [[ ! ${DISTUTILS_SINGLE_IMPL} ]]; then
		local -x HOME=${HOME}/${EPYTHON}
		mkdir -p "${HOME}" || die
	fi

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

	if [[ ! ${DISTUTILS_SINGLE_IMPL} ]]; then
		local best_impl patterns=( "${DISTUTILS_ALL_SUBPHASE_IMPLS[@]-*}" )
		_distutils_try_impl() {
			local pattern
			for pattern in "${patterns[@]}"; do
				if [[ ${EPYTHON} == ${pattern} ]]; then
					best_impl=${MULTIBUILD_VARIANT}
				fi
			done
		}
		python_foreach_impl _distutils_try_impl

		local PYTHON_COMPAT=( "${best_impl}" )
	fi

	_distutils-r1_run_foreach_impl "${@}"
}

# @FUNCTION: _distutils-r1_run_foreach_impl
# @INTERNAL
# @DESCRIPTION:
# Run the given phase for each implementation if multiple implementations
# are enabled, once otherwise.
_distutils-r1_run_foreach_impl() {
	debug-print-function ${FUNCNAME} "${@}"

	if [[ ${DISTUTILS_NO_PARALLEL_BUILD} ]]; then
		eqawarn "DISTUTILS_NO_PARALLEL_BUILD is no longer meaningful. Now all builds"
		eqawarn "are non-parallel. Please remove it from the ebuild."

		unset DISTUTILS_NO_PARALLEL_BUILD # avoid repeated warnings
	fi

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
		eqawarn "QA warning: python_prepare_all() didn't call distutils-r1_python_prepare_all"
	fi

	if declare -f python_prepare >/dev/null; then
		_distutils-r1_run_foreach_impl python_prepare
	fi
}

distutils-r1_src_configure() {
	python_export_utf8_locale

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

_clean_egg_info() {
	# Work around for setuptools test behavior (bug 534058).
	# https://bitbucket.org/pypa/setuptools/issue/292
	rm -rf "${BUILD_DIR}"/lib/*.egg-info
}

distutils-r1_src_test() {
	debug-print-function ${FUNCNAME} "${@}"

	if declare -f python_test >/dev/null; then
		_distutils-r1_run_foreach_impl python_test
		_distutils-r1_run_foreach_impl _clean_egg_info
	fi

	if declare -f python_test_all >/dev/null; then
		_distutils-r1_run_common_phase python_test_all
	fi
}

distutils-r1_src_install() {
	debug-print-function ${FUNCNAME} "${@}"

	if declare -f python_install >/dev/null; then
		_distutils-r1_run_foreach_impl python_install
	else
		_distutils-r1_run_foreach_impl distutils-r1_python_install
	fi

	local _DISTUTILS_DEFAULT_CALLED

	if declare -f python_install_all >/dev/null; then
		_distutils-r1_run_common_phase python_install_all
	else
		_distutils-r1_run_common_phase distutils-r1_python_install_all
	fi

	if [[ ! ${_DISTUTILS_DEFAULT_CALLED} ]]; then
		eqawarn "QA warning: python_install_all() didn't call distutils-r1_python_install_all"
	fi
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
