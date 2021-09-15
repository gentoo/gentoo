# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Run-time type checker for Python"
HOMEPAGE="
	https://pypi.org/project/typeguard/
	https://github.com/agronholm/typeguard/"
SRC_URI="
	https://github.com/agronholm/typeguard/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

python_test() {
	local -x PYTHONDONTWRITEBYTECODE=
	local deselect=()
	[[ ${EPYTHON} == python3.10 ]] && deselect+=(
		# https://github.com/agronholm/typeguard/issues/199
		tests/test_typeguard.py::TestCheckArgumentTypes::test_newtype
	)
	# mypy changes results from version to version
	epytest --ignore tests/mypy ${deselect[@]/#/--deselect }
}
