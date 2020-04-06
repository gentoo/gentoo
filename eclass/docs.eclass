# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: docs.eclass
# @MAINTAINER:
# Andrew Ammerlaan <andrewammerlaan@riseup.net>
# @AUTHOR:
# Author: Andrew Ammerlaan <andrewammerlaan@riseup.net>
# Based on the work of: Michał Górny <mgorny@gentoo.org>
# @SUPPORTED_EAPIS: 5 6 7
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
# doc builders. To do this, add a <DOCBUILDER>-setup and
# <DOCBUILDER>-build function for your doc builder.
# For python based doc builders you can use the 
# python_append_deps function to append [${PYTHON_USEDEP}]
# automatically to additional dependencies
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

# @ECLASS-VARIABLE: DOCBUILDER
# @REQUIRED
# @PRE_INHERIT
# @DESCRIPTION:
# Sets the doc builder to use, currently supports
# sphinx and mkdocs

# @ECLASS-VARIABLE: DOCDIR
# @DESCRIPTION:
# Sets the location of the doc builder config file.
#
# For sphinx this is the location of "conf.py"
# For mkdocs this is the location of "mkdocs.yml"
#
# Note that mkdocs.yml often does not reside
# in the same directory as the actual doc files
#
# Defaults to ${S}

# @ECLASS-VARIABLE: DOCDEPEND
# @DEFAULT_UNSET
# @PRE_INHERIT
# @DESCRIPTION:
# Sets additional dependencies to build docs.
# For sphinx and mkdocs these dependencies should
# be specified without [${PYTHON_USEDEP}], this
# is added by the eclass. E.g. to depend on mkdocs-material:
#
# DOCDEPEND="dev-python/mkdocs-material"
#
# This eclass appends to this variable, so you can
# call it later in your ebuild again if necessary.

# @ECLASS-VARIABLE: AUTODOC
# @PRE_INHERIT
# @DESCRIPTION:
# Sets whether to use sphinx.ext.autodoc/mkautodoc
# Defaults to 1 (True) for sphinx, and 0 (False) for mkdocs

# @ECLASS-VARIABLE: OUTDIR
# @DESCRIPTION:
# Sets where the compiled files will be put.
# There's no real reason to change this, but this
# variable is useful if you want to overwrite the HTML_DOCS
# added by this eclass. E.g.:
#
# HTML_DOCS=( "${yourdocs}" "${OUTDIR}/." )
#
# Defaults to ${DOCDIR}/_build/html

if [[ ! ${_DOCS} ]]; then

# For the python based DOCBUILDERS we need to inherit python-any-r1
case "${DOCBUILDER}" in
	"sphinx"|"mkdocs")
		# If this is not a python package then
		# this is not already set, so we need
		# to set this to inherit python-any-r1
		if [[ -z "${PYTHON_COMPAT}" ]]; then
			PYTHON_COMPAT=( python3_{6,7,8} )
		fi

		# Inherit python-any-r1 if neither python-any-r1 nor
		# python-r1 have been inherited, because we need the
		# python_gen_any_dep function
		if [[ ! ${_PYTHON_R1} && ! ${_PYTHON_ANY_R1} ]]; then
			inherit python-any-r1
		fi
		;;
	"")
		die "DOCBUILDER unset, should be set to use ${ECLASS}"
		;;
	*)
		die "Unsupported DOCBUILDER=${DOCBUILDER} (unknown) for ${ECLASS}"
		;;
esac

# @FUNCTION: python_check_deps
# @DESCRIPTION:
# Check if the dependencies are valid
python_check_deps() {
	debug-print-function ${FUNCNAME}
	use doc || return 0

	local dep
	for dep in ${check_deps[@]}; do
		has_version "${dep}[${PYTHON_USEDEP}]" || return 1
	done
}
# Save this before we start manipulating it
check_deps=${DOCDEPEND}

# @FUNCTION: python_append_dep
# @DESCRIPTION:
# Appends [\${PYTHON_USEDEP}] to all dependencies
# for python based DOCBUILDERs such as mkdocs or
# sphinx.
python_append_deps() {
	debug-print-function ${FUNCNAME}

	local temp=()
	local dep
	for dep in ${DOCDEPEND[@]}; do
		temp+=" ${dep}[\${PYTHON_USEDEP}]"
	done
	DOCDEPEND=${temp}
}

# @FUNCTION: sphinx_setup
# @DESCRIPTION:
# Sets dependencies for sphinx
sphinx_setup() {
	debug-print-function ${FUNCNAME}

	: ${AUTODOC:=1}

	if [[ ${AUTODOC} == 0 && -n "${DOCDEPEND}" ]]; then
		die "${FUNCNAME}: do not set autodoc to 0 if external plugins are used"
	fi
	if [[ ${AUTODOC} == 1 ]]; then
		DOCDEPEND="$(python_gen_any_dep "
			dev-python/sphinx[\${PYTHON_USEDEP}]
			${DOCDEPEND}")"

	else
		DOCDEPEND="dev-python/sphinx"
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

	local confpy=${DOCDIR}/conf.py
	[[ -f ${confpy} ]] ||
		die "${confpy} not found, DOCDIR=${DOCDIR} call wrong"

	if [[ ${AUTODOC} == 0 ]]; then
		if grep -F -q 'sphinx.ext.autodoc' "${confpy}"; then
			die "${FUNCNAME}: autodoc disabled but sphinx.ext.autodoc found in ${confpy}"
		fi
	elif [[ ${AUTODOC} == 1 ]]; then
		if ! grep -F -q 'sphinx.ext.autodoc' "${confpy}"; then
			die "${FUNCNAME}: sphinx.ext.autodoc not found in ${confpy}, set AUTODOC=0"
		fi
	fi
	
	sed -i -e 's:^intersphinx_mapping:disabled_&:' \
		"${DOCDIR}"/conf.py || die
	# not all packages include the Makefile in pypi tarball
	sphinx-build -b html -d "${DOCDIR}"/_build/doctrees "${DOCDIR}" \
	"${OUTDIR}" || die
}

# @FUNCTION: mkdocs_setup
# @DESCRIPTION:
# Sets dependencies for mkdocs
mkdocs_setup() {
	debug-print-function ${FUNCNAME}

	: ${AUTODOC:=0}

	if [[ ${AUTODOC} == 1 ]]; then
		DOCDEPEND="$(python_gen_any_dep "
			dev-python/mkdocs[\${PYTHON_USEDEP}]
			dev-python/mkautodoc[\${PYTHON_USEDEP}]
		${DOCDEPEND}")"
	else
		DOCDEPEND="$(python_gen_any_dep "
			dev-python/mkdocs[\${PYTHON_USEDEP}]
			${DOCDEPEND}")"
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

	local mkdocsyml=${DOCDIR}/mkdocs.yml
	[[ -f ${mkdocsyml} ]] ||
		die "${mkdocsyml} not found, DOCDIR=${DOCDIR} wrong"

	pushd "${DOCDIR}"
	mkdocs build -d "${OUTDIR}" || die
	popd

	# remove generated .gz variants
	# mkdocs currently has no option to disable this
	# and portage complains: "Colliding files found by ecompress"
	rm "${OUTDIR}"/*.gz || die
}

# @FUNCTION: docs_compile
# @DESCRIPTION:
# Calls DOCBUILDER and sets HTML_DOCS
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

	# Set a sensible default as DOCDIR
	: ${DOCDIR:="${S}"}

	# Where to put the compiled files?
	: ${OUTDIR:="${DOCDIR}/_build/html"}

	case "${DOCBUILDER}" in
		"sphinx")
			sphinx_compile
			;;
		"mkdocs")
			mkdocs_compile
			;;
	esac

	HTML_DOCS+=( "${OUTDIR}/." )

	# we need to ensure successful return in case we're called last,
	# otherwise Portage may wrongly assume sourcing failed
	return 0
}


# This is where we setup the USE/(B)DEPEND variables
# and call the doc builder specific setup functions
IUSE+=" doc"

# Call the correct setup function
case "${DOCBUILDER}" in
	"sphinx")
		python_append_deps
		sphinx_setup
		;;
	"mkdocs")
		python_append_deps
		mkdocs_setup
		;;
esac

if [[ ${EAPI} == [56] ]]; then
	DEPEND+=" doc? ( ${DOCDEPEND} )"
else
	BDEPEND+=" doc? ( ${DOCDEPEND} )"
fi

# If this is a python package using distutils-r1
# then put the compile function in the specific
# python function, else just put it in src_compile
if [[ ${_DISTUTILS_R1} ]]; then
	python_compile_all() { docs_compile; }
else
	src_compile() { docs_compile; }
fi

_DOCS=1
fi
