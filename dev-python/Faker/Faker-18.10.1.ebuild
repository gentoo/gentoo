# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="A Python package that generates fake data for you"
HOMEPAGE="
	https://github.com/joke2k/faker/
	https://pypi.org/project/Faker/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/python-dateutil-2.4.2[${PYTHON_USEDEP}]
	!dev-ruby/faker
"
BDEPEND="
	test? (
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP},tiff]
		dev-python/validators[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
