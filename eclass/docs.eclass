# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: docs.eclass
# @MAINTAINER:
# Andrew Ammerlaan <andrewammerlaan@gentoo.org>
# @AUTHOR:
# Author: Andrew Ammerlaan <andrewammerlaan@gentoo.org>
# Based on the work of: Michał Górny <mgorny@gentoo.org>
# @SUPPORTED_EAPIS: 6 7 8
# @BLURB: A simple eclass to build documentation.
# @DESCRIPTION:
# A simple eclass providing basic functions and variables to build
# documentation.
#
# Please note that this eclass appends to ``RDEPEND`` and ``DEPEND``
# unconditionally for you.
#
# This eclass also appends ``doc`` to ``IUSE``, and sets ``HTML_DOCS``
# to the location of the compiled documentation automatically,
# ``einstalldocs`` will then automatically install the documentation
# to the correct directory.
#
# The aim of this eclass is to make it easy to add additional
# doc builders. To do this, add a ``<DOCS_BUILDER>_deps`` and
# ``<DOCS_BUILDER>_compile`` function for your doc builder.
# For python based doc builders you can use the
# ``python_append_deps`` function to append ``[${PYTHON_USEDEP}]``
# automatically to additional dependencies.
#
# Example use ``doxygen``:
# @CODE
# DOCS_BUILDER="doxygen"
# DOCS_DEPEND="media-gfx/imagemagick"
# DOCS_DIR="docs"
#
# inherit docs
#
# ...
#
# src_compile() {
# 	default
# 	docs_compile
# }
# @CODE
#
# Example use mkdocs with ``distutils-r1``:
# @CODE
# DOCS_BUILDER="mkdocs"
# DOCS_DEPEND="dev-python/mkdocs-material"
# DOCS_DIR="doc"
#
# PYTHON_COMPAT=( python3_{8..10} )
#
# inherit distutils-r1 docs
#
# ...
# @CODE

case "${EAPI:-0}" in
	0|1|2|3|4|5)
		die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}"
		;;
	6|7|8)
		;;
	*)
		die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
		;;
esac

# @ECLASS_VARIABLE: DOCS_BUILDER
# @REQUIRED
# @PRE_INHERIT
# @DESCRIPTION:
# Sets the doc builder to use, currently supports
# ``sphinx``, ``mkdocs`` and ``doxygen``.
# ``PYTHON_COMPAT`` should be set for python based
# doc builders: ``sphinx`` and ``mkdocs``

# @ECLASS_VARIABLE: DOCS_DIR
# @DESCRIPTION:
# Path containing the doc builder config file(s).
#
# For ``sphinx`` this is the location of ``conf.py``
#
# For ``mkdocs`` this is the location of ``mkdocs.yml``
# Note that ``mkdocs.yml`` often does not reside
# in the same directory as the actual doc files
#
# For ``doxygen`` the default name is ``Doxyfile``, but
# package may use a non-standard name. If this
# is the case one should set ``DOCS_CONFIG_NAME`` to
# the correct name
#
# Defaults to ``${S}``

# @ECLASS_VARIABLE: DOCS_DEPEND
# @DEFAULT_UNSET
# @PRE_INHERIT
# @DESCRIPTION:
# Sets additional dependencies required to build the
# documentation.
# For ``sphinx`` and ``mkdocs`` these dependencies should
# be specified *without* ``[${PYTHON_USEDEP}]``, this
# is added by the eclass. E.g. to depend on ``mkdocs-material``:
#
# @CODE
# DOCS_DEPEND="dev-python/mkdocs-material"
# @CODE
#
# This eclass appends to this variable, this makes it
# possible to call it later in your ebuild again if
# necessary.

# @ECLASS_VARIABLE: DOCS_AUTODOC
# @PRE_INHERIT
# @DESCRIPTION:
# Sets whether to use ``sphinx.ext.autodoc``/``mkautodoc``
# Defaults to 1 (True) for ``sphinx``, and 0 (False) for ``mkdocs``.
# Not relevant for ``doxygen``.

# @ECLASS_VARIABLE: DOCS_OUTDIR
# @DESCRIPTION:
# Sets the directory where the documentation should
# be built into. There is no real reason to change this.
# However, this variable is useful if the package should
# also install other HTML files.
#
# Example use:
# @CODE
# HTML_DOCS=( "${yourdocs}" "${DOCS_OUTDIR}/." )
# @CODE
#
# Defaults to ``${S}/_build/html``

# @ECLASS_VARIABLE: DOCS_CONFIG_NAME
# @DESCRIPTION:
# Name of the doc builder config file.
#
# Only relevant for ``doxygen``, as it allows
# config files with non-standard names.
# Does not do anything for ``mkdocs`` or ``sphinx``.
#
# Defaults to ``Doxyfile`` for ``doxygen``

if [[ ! ${_DOCS} ]]; then

# For the python based DOCS_BUILDERS we need to inherit any python eclass
case ${DOCS_BUILDER} in
	"sphinx"|"mkdocs")
		# We need the python_gen_any_dep function
		if [[ ! ${_PYTHON_R1} && ! ${_PYTHON_ANY_R1} && ! ${_PYTHON_SINGLE_R1} ]]; then
			die "distutils-r1, python-r1, python-single-r1 or python-any-r1 needs to be inherited to use python based documentation builders"
		fi
		;;
	"doxygen")
		# do not need to inherit anything for doxygen
		;;
	"")
		die "DOCS_BUILDER unset, should be set to use ${ECLASS}"
		;;
	*)
		die "Unsupported DOCS_BUILDER=${DOCS_BUILDER} (unknown) for ${ECLASS}"
		;;
esac

# @FUNCTION: python_append_deps
# @INTERNAL
# @DESCRIPTION:
# Appends [\${PYTHON_USEDEP}] to all dependencies
# for python based DOCS_BUILDERs such as mkdocs or
# sphinx.
python_append_deps() {
	debug-print-function ${FUNCNAME}

	local temp
	local dep
	for dep in ${DOCS_DEPEND[@]}; do
		temp+=" ${dep}[\${PYTHON_USEDEP}]"
	done
	DOCS_DEPEND=${temp}
}

# @FUNCTION: sphinx_deps
# @INTERNAL
# @DESCRIPTION:
# Sets dependencies for sphinx
sphinx_deps() {
	debug-print-function ${FUNCNAME}

	: ${DOCS_AUTODOC:=1}

	deps="dev-python/sphinx[\${PYTHON_USEDEP}]
			${DOCS_DEPEND}"
	if [[ ${DOCS_AUTODOC} == 0 ]]; then
		if [[ -n "${DOCS_DEPEND}" ]]; then
			die "${FUNCNAME}: do not set DOCS_AUTODOC to 0 if external plugins are used"
		fi
	elif [[ ${DOCS_AUTODOC} != 0 && ${DOCS_AUTODOC} != 1 ]]; then
		die "${FUNCNAME}: DOCS_AUTODOC should be set to 0 or 1"
	fi
	if [[ ${_PYTHON_SINGLE_R1} ]]; then
		DOCS_DEPEND="$(python_gen_cond_dep "${deps}")"
	else
		DOCS_DEPEND="$(python_gen_any_dep "${deps}")"
	fi
}

# @FUNCTION: sphinx_compile
# @INTERNAL
# @DESCRIPTION:
# Calls sphinx to build docs.
#
# If you overwrite python_compile_all do not call
# this function, call docs_compile instead
sphinx_compile() {
	debug-print-function ${FUNCNAME}
	use doc || return

	local confpy=${DOCS_DIR}/conf.py
	[[ -f ${confpy} ]] ||
		die "${FUNCNAME}: ${confpy} not found, DOCS_DIR=${DOCS_DIR} call wrong"

	if [[ ${DOCS_AUTODOC} == 0 ]]; then
		if grep -F -q 'sphinx.ext.autodoc' "${confpy}"; then
			die "${FUNCNAME}: autodoc disabled but sphinx.ext.autodoc found in ${confpy}"
		fi
	elif [[ ${DOCS_AUTODOC} == 1 ]]; then
		if ! grep -F -q 'sphinx.ext.autodoc' "${confpy}"; then
			die "${FUNCNAME}: sphinx.ext.autodoc not found in ${confpy}, set DOCS_AUTODOC=0"
		fi
	fi

	sed -i -e 's:^intersphinx_mapping:disabled_&:' \
		"${DOCS_DIR}"/conf.py || die
	# not all packages include the Makefile in pypi tarball
	sphinx-build -b html -d "${DOCS_OUTDIR}"/_build/doctrees "${DOCS_DIR}" \
	"${DOCS_OUTDIR}" || die "${FUNCNAME}: sphinx-build failed"
}

# @FUNCTION: mkdocs_deps
# @INTERNAL
# @DESCRIPTION:
# Sets dependencies for mkdocs
mkdocs_deps() {
	debug-print-function ${FUNCNAME}

	: ${DOCS_AUTODOC:=0}

	deps="dev-python/mkdocs[\${PYTHON_USEDEP}]
			${DOCS_DEPEND}"
	if [[ ${DOCS_AUTODOC} == 1 ]]; then
		deps="dev-python/mkautodoc[\${PYTHON_USEDEP}]
				${deps}"
	elif [[ ${DOCS_AUTODOC} != 0 && ${DOCS_AUTODOC} != 1 ]]; then
		die "${FUNCNAME}: DOCS_AUTODOC should be set to 0 or 1"
	fi
	if [[ ${_PYTHON_SINGLE_R1} ]]; then
		DOCS_DEPEND="$(python_gen_cond_dep "${deps}")"
	else
		DOCS_DEPEND="$(python_gen_any_dep "${deps}")"
	fi
}

# @FUNCTION: mkdocs_compile
# @INTERNAL
# @DESCRIPTION:
# Calls mkdocs to build docs.
#
# If you overwrite python_compile_all do not call
# this function, call docs_compile instead
mkdocs_compile() {
	debug-print-function ${FUNCNAME}
	use doc || return

	local mkdocsyml=${DOCS_DIR}/mkdocs.yml
	[[ -f ${mkdocsyml} ]] ||
		die "${FUNCNAME}: ${mkdocsyml} not found, DOCS_DIR=${DOCS_DIR} wrong"

	pushd "${DOCS_DIR}" || die
	mkdocs build -d "${DOCS_OUTDIR}" || die "${FUNCNAME}: mkdocs build failed"
	popd || die

	# remove generated .gz variants
	# mkdocs currently has no option to disable this
	# and portage complains: "Colliding files found by ecompress"
	rm "${DOCS_OUTDIR}"/*.gz || die
}

# @FUNCTION: doxygen_deps
# @INTERNAL
# @DESCRIPTION:
# Sets dependencies for doxygen
doxygen_deps() {
	debug-print-function ${FUNCNAME}

	DOCS_DEPEND="app-doc/doxygen
		${DOCS_DEPEND}"
}

# @FUNCTION: doxygen_compile
# @INTERNAL
# @DESCRIPTION:
# Calls doxygen to build docs.
doxygen_compile() {
	debug-print-function ${FUNCNAME}
	use doc || return

	: ${DOCS_CONFIG_NAME:="Doxyfile"}

	local doxyfile=${DOCS_DIR}/${DOCS_CONFIG_NAME}
	[[ -f ${doxyfile} ]] ||
		die "${FUNCNAME}: ${doxyfile} not found, DOCS_DIR=${DOCS_DIR} or DOCS_CONFIG_NAME=${DOCS_CONFIG_NAME} wrong"

	# doxygen wants the HTML_OUTPUT dir to already exist
	mkdir -p "${DOCS_OUTDIR}" || die

	pushd "${DOCS_DIR}" || die
	(cat "${DOCS_CONFIG_NAME}" ; echo "HTML_OUTPUT=${DOCS_OUTDIR}") | doxygen - || die "${FUNCNAME}: doxygen failed"
	popd || die
}

# @FUNCTION: docs_compile
# @DESCRIPTION:
# Calls ``DOCS_BUILDER`` and sets ``HTML_DOCS``
#
# This function must be called in ``src_compile``. Take care not to
# overwrite the variables set by it. If ``distutils-r1`` is inherited
# *before* this eclass, than ``docs_compile`` will be automatically
# added to ``python_compile_all()`` and there is no need to call
# it manually. Note that this function checks if ``USE="doc"`` is
# enabled, and if not automatically exits. Therefore, there is
# no need to wrap this function in a ``if`` statement.
#
# Example use:
# @CODE
# src_compile() {
# 	default
# 	docs_compile
# }
# @CODE
docs_compile() {
	debug-print-function ${FUNCNAME}
	use doc || return

	# Set a sensible default as DOCS_DIR
	: ${DOCS_DIR:="${S}"}

	# Where to put the compiled files?
	: ${DOCS_OUTDIR:="${S}/_build/html"}

	${DOCS_BUILDER}_compile

	HTML_DOCS+=( "${DOCS_OUTDIR}/." )

	# we need to ensure successful return in case we're called last,
	# otherwise Portage may wrongly assume sourcing failed
	return 0
}


# This is where we setup the USE/(B)DEPEND variables
# and call the doc builder specific setup functions
IUSE+=" doc"

# Call the correct setup function
case ${DOCS_BUILDER} in
	"sphinx")
		python_append_deps
		sphinx_deps
		;;
	"mkdocs")
		python_append_deps
		mkdocs_deps
		;;
	"doxygen")
		doxygen_deps
		;;
esac

if [[ ${EAPI} != 6 ]]; then
	BDEPEND+=" doc? ( ${DOCS_DEPEND} )"
else
	DEPEND+=" doc? ( ${DOCS_DEPEND} )"
fi

# If this is a python package using distutils-r1
# then put the compile function in the specific
# python function, else docs_compile should be manually
# added to src_compile
if [[ ${_DISTUTILS_R1} && ( ${DOCS_BUILDER}="mkdocs" || ${DOCS_BUILDER}="sphinx" ) ]]; then
	python_compile_all() { docs_compile; }
fi

_DOCS=1
fi
