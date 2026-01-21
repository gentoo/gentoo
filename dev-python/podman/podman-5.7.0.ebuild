# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

MY_P=podman-py-${PV/_p/.post}
DESCRIPTION="A library to interact with a Podman server"
HOMEPAGE="
	https://github.com/containers/podman-py/
	https://pypi.org/project/podman/
"
SRC_URI="
	https://github.com/containers/podman-py/archive/v${PV/_p/.post}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/requests-2.24[${PYTHON_USEDEP}]
	>=dev-python/rich-12.5.1[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/requests-mock-1.11.0[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# TODO
		podman/tests/unit/test_volumesmanager.py::VolumesManagerTestCase::test_get_404
	)

	# integration tests require a workable podman server,
	# and it doesn't seem to work in ebuild env
	epytest podman/tests/unit
}
