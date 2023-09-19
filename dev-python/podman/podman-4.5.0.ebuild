# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

MY_P=podman-py-${PV}
DESCRIPTION="A library to interact with a Podman server"
HOMEPAGE="
	https://github.com/containers/podman-py/
	https://pypi.org/project/podman/
"
SRC_URI="
	https://github.com/containers/podman-py/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/pyxdg-0.26[${PYTHON_USEDEP}]
	>=dev-python/requests-2.24[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.26.5[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/tomli-1.2.3[${PYTHON_USEDEP}]
	' 3.{8..10})
"
BDEPEND="
	test? (
		dev-python/requests-mock[${PYTHON_USEDEP}]
	)
"

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
