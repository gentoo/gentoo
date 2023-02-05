# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: pypi.eclass
# @MAINTAINER:
# Michał Górny <mgorny@gentoo.org>
# @AUTHOR:
# Michał Górny <mgorny@gentoo.org>
# @SUPPORTED_EAPIS: 8
# @BLURB: A helper eclass to generate PyPI source URIs
# @DESCRIPTION:
# The pypi.eclass can be used to easily obtain URLs for artifacts
# uploaded to PyPI.org.  When inherited, the eclass defaults SRC_URI
# to fetch ${P}.tar.gz sdist.
#
# If necessary, SRC_URI can be overriden by the ebuild.  Two helper
# functions, pypi_sdist_url and pypi_wheel_url are provided to generate
# URLs to artifacts of specified type, with customizable project name.
# Additionally, pypi_wheel_name can be used to generate wheel filename.
#
# @EXAMPLE:
# @CODE@
# inherit pypi
#
# SRC_URI="$(pypi_sdist_url "${PN^}" "${PV}")"
# S=${WORKDIR}/${P^}
# @CODE@

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! ${_PYPI_ECLASS} ]]; then
_PYPI_ECLASS=1

SRC_URI="
	https://files.pythonhosted.org/packages/source/${PN::1}/${PN}/${P}.tar.gz
"

# @FUNCTION: pypi_sdist_url
# @USAGE: [<project> [<version> [<suffix>]]]
# @DESCRIPTION:
# Output the URL to PyPI sdist for specified project/version tuple.
#
# If <package> is unspecified, it defaults to ${PN}.
#
# If <version> is unspecified, it defaults to ${PV}.
#
# If <format> is unspecified, it defaults to ".tar.gz".  Another valid
# value is ".zip" (please remember to add a BDEPEND on app-arch/unzip).
pypi_sdist_url() {
	if [[ ${#} -gt 3 ]]; then
		die "Usage: ${FUNCNAME} <project> [<version> [<suffix>]]"
	fi

	local project=${1-"${PN}"}
	local version=${2-"${PV}"}
	local suffix=${3-.tar.gz}
	printf "https://files.pythonhosted.org/packages/source/%s" \
		"${project::1}/${project}/${project}-${version}${suffix}"
}

# @FUNCTION: pypi_wheel_name
# @USAGE: [<project> [<version> [<python-tag> [<abi-platform-tag>]]]]
# @DESCRIPTION:
# Output the wheel filename for the specified project/version tuple.
#
# If <package> is unspecified, it defaults to ${PN}.
#
# If <version> is unspecified, it defaults to ${PV}.
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

	local project=${1-"${PN}"}
	local version=${2-"${PV}"}
	local pytag=${3-py3}
	local abitag=${4-none-any}
	echo "${project}-${version}-${pytag}-${abitag}.whl"
}

# @FUNCTION: pypi_wheel_url
# @USAGE: [<project> [<version> [<python-tag> [<abi-platform-tag>]]]]
# @DESCRIPTION:
# Output the URL to PyPI wheel for specified project/version tuple.
#
# If <package> is unspecified, it defaults to ${PN}.
#
# If <version> is unspecified, it defaults to ${PV}.
#
# If <python-tag> is unspecified, it defaults to "py3".  It can also be
# "py2.py3", or a specific version in case of non-pure wheels.
#
# If <abi-platform-tag> is unspecified, it defaults to "none-any".
# You need to specify the correct value for non-pure wheels,
# e.g. "abi3-linux_x86_64".
#
# Note that wheels are suffixed .whl by default and therefore are not
# unpacked automatically.  If you need automatic unpacking, use "->"
# operator to rename it or call unzip directly.  Remember to BDEPEND
# on app-arch/unzip.
pypi_wheel_url() {
	if [[ ${#} -gt 4 ]]; then
		die "Usage: ${FUNCNAME} <project> [<version> [<python-tag> [<abi-platform-tag>]]]"
	fi

	local project=${1-"${PN}"}
	local version=${2-"${PV}"}
	local pytag=${3-py3}
	printf "https://files.pythonhosted.org/packages/%s" \
		"${pytag}/${project::1}/${project}/$(pypi_wheel_name "${@}")"
}

fi
