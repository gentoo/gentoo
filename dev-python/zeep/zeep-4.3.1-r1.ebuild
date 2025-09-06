# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="A modern/fast Python SOAP client based on lxml / requests"
HOMEPAGE="
	https://docs.python-zeep.org/
	https://github.com/mvantellingen/python-zeep/
	https://pypi.org/project/zeep/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc64 ~riscv x86"
IUSE="async"

RDEPEND="
	>=dev-python/attrs-17.2.0[${PYTHON_USEDEP}]
	>=dev-python/isodate-0.5.4[${PYTHON_USEDEP}]
	>=dev-python/lxml-4.6.0[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.7.0[${PYTHON_USEDEP}]
	>=dev-python/requests-file-1.5.1[${PYTHON_USEDEP}]
	>=dev-python/requests-toolbelt-0.7.1[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	async? ( >=dev-python/httpx-0.15.0[${PYTHON_USEDEP}] )
"
BDEPEND="
	test? (
		dev-python/freezegun[${PYTHON_USEDEP}]
		>=dev-python/httpx-0.15.0[${PYTHON_USEDEP}]
		dev-python/pretend[${PYTHON_USEDEP}]
		dev-python/requests-mock[${PYTHON_USEDEP}]
		dev-python/xmlsec[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-{asyncio,httpx} )
distutils_enable_tests pytest

PATCHES=(
	# https://github.com/mvantellingen/python-zeep/pull/1468
	"${FILESDIR}/${P}-httpx-0.28.patch"
)
