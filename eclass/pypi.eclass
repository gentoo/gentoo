# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: pypi.eclass
# @MAINTAINER:
# Michał Górny <mgorny@gentoo.org>
# @AUTHOR:
# Michał Górny <mgorny@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: A helper eclass to generate PyPI source URIs
# @DESCRIPTION:
# The pypi.eclass can be used to easily obtain URLs for artifacts
# uploaded to PyPI.org.  When inherited, the eclass defaults SRC_URI
# and S to fetch .tar.gz sdist.  The project filename is normalized
# by default (unless PYPI_NO_NORMALIZE is set prior to inheriting
# the eclass), and the version is translated using
# pypi_translate_version.
#
# If necessary, SRC_URI and S can be overridden by the ebuild.  Two
# helper functions, pypi_sdist_url and pypi_wheel_url are provided
# to generate URLs to artifacts of specified type, with customizable
# URL components.  Additionally, pypi_wheel_name can be used to generate
# wheel filename.
#
# pypi_normalize_name can be used to normalize an arbitrary project name
# according to sdist/wheel normalization rules.  pypi_translate_version
# can be used to translate a Gentoo version string into its PEP 440
# equivalent.
#
# @EXAMPLE:
# @CODE
# inherit pypi
#
# SRC_URI="$(pypi_sdist_url "${PN^}" "${PV}")"
# S=${WORKDIR}/${P^}
# @CODE

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! ${_PYPI_ECLASS} ]]; then
_PYPI_ECLASS=1

# @ECLASS_VARIABLE: PYPI_NO_NORMALIZE
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# When set to a non-empty value, disables project name normalization
# for the default SRC_URI and S values.

# @ECLASS_VARIABLE: PYPI_PN
# @PRE_INHERIT
# @DESCRIPTION:
# The PyPI project name.  This should be overridden scarcely, generally
# when upstream project name does not conform to Gentoo naming rules,
# e.g. when it contains dots or uppercase letters.
#
# Example use:
# @CODE
# PYPI_PN=${PN/-/.}
# @CODE
: "${PYPI_PN:=${PN}}"

# @FUNCTION: _pypi_normalize_name
# @INTERNAL
# @USAGE: <name>
# @DESCRIPTION:
# Internal normalization function, returns the result
# via _PYPI_NORMALIZED_NAME variable.
_pypi_normalize_name() {
	# NB: it's fine to alter it unconditionally since this function is
	# always called from a subshell or in global scope
	# (via _pypi_set_globals)
	shopt -s extglob
	local name=${1//+([._-])/_}
	shopt -u extglob
	_PYPI_NORMALIZED_NAME="${name,,}"
}

# @FUNCTION: pypi_normalize_name
# @USAGE: <name>
# @DESCRIPTION:
# Normalize the project name according to sdist/wheel normalization
# rules.  That is, convert to lowercase and replace runs of [._-]
# with a single underscore.
#
# Based on the spec, as of 2023-02-10:
# https://packaging.python.org/en/latest/specifications/#package-distribution-file-formats
pypi_normalize_name() {
	[[ ${#} -ne 1 ]] && die "Usage: ${FUNCNAME} <name>"

	local _PYPI_NORMALIZED_NAME
	_pypi_normalize_name "${@}"
	echo "${_PYPI_NORMALIZED_NAME}"
}

# @FUNCTION: _pypi_translate_version
# @USAGE: <version>
# @DESCRIPTION:
# Internal version translation function, returns the result
# via _PYPI_TRANSLATED_VERSION variable.
_pypi_translate_version() {
	local version=${1}
	version=${version/_alpha/a}
	version=${version/_beta/b}
	version=${version/_pre/.dev}
	version=${version/_rc/rc}
	_PYPI_TRANSLATED_VERSION=${version/_p/.post}
}

# @FUNCTION: pypi_translate_version
# @USAGE: <version>
# @DESCRIPTION:
# Translate the specified Gentoo version into the usual Python
# counterpart.  Assumes PEP 440 versions.
#
# Note that we do not have clear counterparts for the epoch segment,
# nor for development release segment.
pypi_translate_version() {
	[[ ${#} -ne 1 ]] && die "Usage: ${FUNCNAME} <version>"

	local _PYPI_TRANSLATED_VERSION
	_pypi_translate_version "${@}"
	echo "${_PYPI_TRANSLATED_VERSION}"
}

# @FUNCTION: _pypi_sdist_url
# @INTERNAL
# @USAGE: [--no-normalize] [<project> [<version> [<suffix>]]]
# @DESCRIPTION:
# Internal sdist generated, returns the result via _PYPI_SDIST_URL
# variable.
_pypi_sdist_url() {
	local normalize=1
	if [[ ${1} == --no-normalize ]]; then
		normalize=
		shift
	fi

	if [[ ${#} -gt 3 ]]; then
		die "Usage: ${FUNCNAME} [--no-normalize] <project> [<version> [<suffix>]]"
	fi

	local project=${1-"${PYPI_PN}"}
	local version=${2-"$(pypi_translate_version "${PV}")"}
	local suffix=${3-.tar.gz}
	local _PYPI_NORMALIZED_NAME=${project}
	[[ ${normalize} ]] && _pypi_normalize_name "${_PYPI_NORMALIZED_NAME}"
	_PYPI_SDIST_URL="https://files.pythonhosted.org/packages/source/${project::1}/${project}/${_PYPI_NORMALIZED_NAME}-${version}${suffix}"
}

# @FUNCTION: pypi_sdist_url
# @USAGE: [--no-normalize] [<project> [<version> [<suffix>]]]
# @DESCRIPTION:
# Output the URL to PyPI sdist for specified project/version tuple.
#
# The `--no-normalize` option disables project name normalization
# for sdist filename.  This may be necessary when dealing with distfiles
# generated using build systems that did not follow PEP 625
# (i.e. the sdist name contains uppercase letters, hyphens or dots).
#
# If <package> is unspecified, it defaults to ${PYPI_PN}.  The package
# name is normalized according to the specification unless
# `--no-normalize` is passed.
#
# If <version> is unspecified, it defaults to ${PV} translated
# via pypi_translate_version.  If it is specified, then it is used
# verbatim (the function can be called explicitly to translate custom
# version number).
#
# If <format> is unspecified, it defaults to ".tar.gz".  Another valid
# value is ".zip" (please remember to add a BDEPEND on app-arch/unzip).
pypi_sdist_url() {
	local _PYPI_SDIST_URL
	_pypi_sdist_url "${@}"
	echo "${_PYPI_SDIST_URL}"
}

# @FUNCTION: pypi_wheel_name
# @USAGE: [<project> [<version> [<python-tag> [<abi-platform-tag>]]]]
# @DESCRIPTION:
# Output the wheel filename for the specified project/version tuple.
#
# If <package> is unspecified, it defaults to ${PYPI_PN}.  The package
# name is normalized according to the wheel specification.
#
# If <version> is unspecified, it defaults to ${PV} translated
# via pypi_translate_version.  If it is specified, then it is used
# verbatim (the function can be called explicitly to translate custom
# version number).
#
# If <python-tag> is unspecified, it defaults to "py3".  It can also be
# "py2.py3", or a specific version in case of non-pure wheels.
#
# If <abi-platform-tag> is unspecified, it defaults to "none-any".
# You need to specify the correct value for non-pure wheels,
# e.g. "abi3-linux_x86_64".
pypi_wheel_name() {
	if [[ ${#} -gt 4 ]]; then
		die "Usage: ${FUNCNAME} <project> [<version> [<python-tag> [<abi-platform-tag>]]]"
	fi

	local _PYPI_NORMALIZED_NAME
	_pypi_normalize_name "${1:-"${PYPI_PN}"}"
	local version=${2-"$(pypi_translate_version "${PV}")"}
	local pytag=${3-py3}
	local abitag=${4-none-any}
	echo "${_PYPI_NORMALIZED_NAME}-${version}-${pytag}-${abitag}.whl"
}

# @FUNCTION: pypi_wheel_url
# @USAGE: [--unpack] [<project> [<version> [<python-tag> [<abi-platform-tag>]]]]
# @DESCRIPTION:
# Output the URL to PyPI wheel for specified project/version tuple.
#
# The `--unpack` option causes a SRC_URI with an arrow operator to
# be generated, that adds a .zip suffix to the fetched distfile,
# so that it is unpacked in default src_unpack().  Note that
# the wheel contents will be unpacked straight into ${WORKDIR}.
# You need to add a BDEPEND on app-arch/unzip.
#
# If <package> is unspecified, it defaults to ${PYPI_PN}.
#
# If <version> is unspecified, it defaults to ${PV} translated
# via pypi_translate_version.  If it is specified, then it is used
# verbatim (the function can be called explicitly to translate custom
# version number).
#
# If <python-tag> is unspecified, it defaults to "py3".  It can also be
# "py2.py3", or a specific version in case of non-pure wheels.
#
# If <abi-platform-tag> is unspecified, it defaults to "none-any".
# You need to specify the correct value for non-pure wheels,
# e.g. "abi3-linux_x86_64".
pypi_wheel_url() {
	local unpack=
	if [[ ${1} == --unpack ]]; then
		unpack=1
		shift
	fi

	if [[ ${#} -gt 4 ]]; then
		die "Usage: ${FUNCNAME} [--unpack] <project> [<version> [<python-tag> [<abi-platform-tag>]]]"
	fi

	local filename=$(pypi_wheel_name "${@}")
	local project=${1-"${PYPI_PN}"}
	local version=${2-"$(pypi_translate_version "${PV}")"}
	local pytag=${3-py3}
	printf "https://files.pythonhosted.org/packages/%s" \
		"${pytag}/${project::1}/${project}/${filename}"

	if [[ ${unpack} ]]; then
		echo " -> ${filename}.zip"
	fi
}

# @FUNCTION: _pypi_set_globals
# @INTERNAL
# @DESCRIPTION:
# Set global variables, SRC_URI and S.
_pypi_set_globals() {
	local _PYPI_SDIST_URL _PYPI_TRANSLATED_VERSION
	_pypi_translate_version "${PV}"

	if [[ ${PYPI_NO_NORMALIZE} ]]; then
		_pypi_sdist_url --no-normalize "${PYPI_PN}" "${_PYPI_TRANSLATED_VERSION}"
		S="${WORKDIR}/${PYPI_PN}-${_PYPI_TRANSLATED_VERSION}"
	else
		local _PYPI_NORMALIZED_NAME
		_pypi_normalize_name "${PYPI_PN}"
		_pypi_sdist_url "${PYPI_PN}" "${_PYPI_TRANSLATED_VERSION}"
		S="${WORKDIR}/${_PYPI_NORMALIZED_NAME}-${_PYPI_TRANSLATED_VERSION}"
	fi

	SRC_URI=${_PYPI_SDIST_URL}
}

_pypi_set_globals

fi
