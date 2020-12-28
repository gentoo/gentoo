# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: docs.eclass
# @MAINTAINER:
# Andrew Ammerlaan <andrewammerlaan@riseup.net>
# @AUTHOR:
# Author: Andrew Ammerlaan <andrewammerlaan@riseup.net>
# Based on the work of: Michał Górny <mgorny@gentoo.org>
# @SUPPORTED_EAPIS: 6 7
# @BLURB: A simple eclass to build documentation.
# @DESCRIPTION:
# A simple eclass providing functions to build documentation.
#
# Please note that docs sets RDEPEND and DEPEND unconditionally
# for you.
#
# This eclass also appends "doc" to IUSE, and sets HTML_DOCS
# to the location of the compiled documentation
#
# The aim of this eclass is to make it easy to add additional
# doc builders. To do this, add a <DOCS_BUILDER>-deps and
# <DOCS_BUILDER>-build function for your doc builder.
# For python based doc builders you can use the
# python_append_deps function to append [${PYTHON_USEDEP}]
# automatically to additional dependencies.

case "${EAPI:-0}" in
	0|1|2|3|4|5)
		die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}"
		;;
	6|7)
		;;
	*)
		die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
		;;
esac

# @ECLASS-VARIABLE: DOCS_BUILDER
# @REQUIRED
# @PRE_INHERIT
# @DESCRIPTION:
# Sets the doc builder to use, currently supports
# sphinx, mkdocs and doxygen.
# PYTHON_COMPAT should be set for python based
# doc builders: sphinx and mkdocs

# @ECLASS-VARIABLE: DOCS_DIR
# @DESCRIPTION:
# Path containing the doc builder config file(s).
#
# For sphinx this is the location of "conf.py"
# For mkdocs this is the location of "mkdocs.yml"
#
# Note that mkdocs.yml often does not reside
# in the same directory as the actual doc files
#
# Defaults to ${S}

# @ECLASS-VARIABLE: DOCS_DEPEND
# @DEFAULT_UNSET
# @PRE_INHERIT
# @DESCRIPTION:
# Sets additional dependencies to build docs.
# For sphinx and mkdocs these dependencies should
# be specified without [${PYTHON_USEDEP}], this
# is added by the eclass. E.g. to depend on mkdocs-material:
#
# DOCS_DEPEND="dev-python/mkdocs-material"
#
# This eclass appends to this variable, so you can
# call it later in your ebuild again if necessary.

# @ECLASS-VARIABLE: DOCS_AUTODOC
# @PRE_INHERIT
# @DESCRIPTION:
# Sets whether to use sphinx.ext.autodoc/mkautodoc
# Defaults to 1 (True) for sphinx, and 0 (False) for mkdocs

# @ECLASS-VARIABLE: DOCS_OUTDIR
# @DESCRIPTION:
# Sets where the compiled files will be put.
# There's no real reason to change this, but this
# variable is useful if you want to overwrite the HTML_DOCS
# added by this eclass. E.g.:
#
# HTML_DOCS=( "${yourdocs}" "${DOCS_OUTDIR}/." )
#
# Defaults to ${S}/_build/html

# @ECLASS-VARIABLE: DOCS_CONFIG_NAME
# @DESCRIPTION:
# Name of the doc builder config file.
#
# Only relevant for doxygen, as it allows
# config files with non-standard names
#
# Defaults to Doxyfile for doxygen

if [[ ! ${_DOCS} ]]; then

# For the python based DOCS_BUILDERS we need to inherit python-any-r1
case ${DOCS_BUILDER} in
	"sphinx"|"mkdocs")
		# We need the python_gen_any_dep function
		if [[ ! ${_PYTHON_R1} && ! ${_PYTHON_ANY_R1} ]]; then
			die "python-r1 or python-any-r1 needs to be inherited as well to use python based documentation builders"
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

# @FUNCTION: python_append_dep
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
# @DESCRIPTION:
# Sets dependencies for sphinx
sphinx_deps() {
	debug-print-function ${FUNCNAME}

	: ${DOCS_AUTODOC:=1}

	if [[ ${DOCS_AUTODOC} == 0 ]]; then
		if [[ -n "${DOCS_DEPEND}" ]]; then
			die "${FUNCNAME}: do not set DOCS_AUTODOC to 0 if external plugins are used"
		else
			DOCS_DEPEND="$(python_gen_any_dep "
			dev-python/sphinx[\${PYTHON_USEDEP}]")"
		fi
	elif [[ ${DOCS_AUTODOC} == 1 ]]; then
		DOCS_DEPEND="$(python_gen_any_dep "
			dev-python/sphinx[\${PYTHON_USEDEP}]
			${DOCS_DEPEND}")"
	else
		die "${FUNCNAME}: DOCS_AUTODOC should be set to 0 or 1"
	fi
}

# @FUNCTION: sphinx_compile
# @DESCRIPTION:
# Calls sphinx to build docs.
#
# If you overwrite src_compile or python_compile_all
# do not call this function, call docs_compile instead
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
# @DESCRIPTION:
# Sets dependencies for mkdocs
mkdocs_deps() {
	debug-print-function ${FUNCNAME}

	: ${DOCS_AUTODOC:=0}

	if [[ ${DOCS_AUTODOC} == 1 ]]; then
		DOCS_DEPEND="$(python_gen_any_dep "
			dev-python/mkdocs[\${PYTHON_USEDEP}]
			dev-python/mkautodoc[\${PYTHON_USEDEP}]
		${DOCS_DEPEND}")"
	elif [[ ${DOCS_AUTODOC} == 0 ]]; then
		DOCS_DEPEND="$(python_gen_any_dep "
			dev-python/mkdocs[\${PYTHON_USEDEP}]
			${DOCS_DEPEND}")"
	else
		die "${FUNCNAME}: DOCS_AUTODOC should be set to 0 or 1"
	fi
}

# @FUNCTION: mkdocs_compile
# @DESCRIPTION:
# Calls mkdocs to build docs.
#
# If you overwrite src_compile or python_compile_all
# do not call this function, call docs_compile instead
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
# @DESCRIPTION:
# Sets dependencies for doxygen
doxygen_deps() {
	debug-print-function ${FUNCNAME}

	DOCS_DEPEND="app-doc/doxygen
		${DOCS_DEPEND}"
}

# @FUNCTION: doxygen_compile
# @DESCRIPTION:
# Calls doxygen to build docs.
#
# If you overwrite src_compile or python_compile_all
# do not call this function, call docs_compile instead
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
# Calls DOCS_BUILDER and sets HTML_DOCS
#
# This function must be called in global scope.  Take care not to
# overwrite the variables set by it. Has support for distutils-r1
# eclass, but only if this eclass is inherited *after*
# distutils-r1. If you need to extend src_compile() or
# python_compile_all(), you can call the original implementation
# as docs_compile.
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

if [[ ${EAPI} == [7] ]]; then
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
