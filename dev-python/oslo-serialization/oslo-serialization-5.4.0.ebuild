# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN=${PN/-/.}
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Oslo Serialization library"
HOMEPAGE="
	https://opendev.org/openstack/oslo.serialization/
	https://github.com/openstack/oslo.serialization/
	https://pypi.org/project/oslo.serialization/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

RDEPEND="
	>=dev-python/msgpack-0.5.2[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.33.0[${PYTHON_USEDEP}]
	dev-python/tzdata[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/pbr-2.2.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/netaddr-0.7.18[${PYTHON_USEDEP}]
		>=dev-python/oslotest-3.2.0[${PYTHON_USEDEP}]
		>=dev-python/oslo-i18n-3.15.3[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest
distutils_enable_sphinx doc/source \
	dev-python/openstackdocstheme

python_prepare_all() {
	# remove spurious rdep on pbr
	sed -i -e '/pbr/d' requirements.txt || die
	distutils-r1_python_prepare_all
}
