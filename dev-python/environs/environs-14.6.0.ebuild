# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYPI_VERIFY_REPO=https://github.com/sloria/environs
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Python library for simplified environment variable parsing"
HOMEPAGE="
	https://github.com/sloria/environs/
	https://pypi.org/project/environs/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	dev-python/python-dotenv[${PYTHON_USEDEP}]
	>=dev-python/marshmallow-3.26.2[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/django-cache-url[${PYTHON_USEDEP}]
		dev-python/dj-database-url[${PYTHON_USEDEP}]
		dev-python/dj-email-url[${PYTHON_USEDEP}]
	)
"

DOCS=( CHANGELOG.md CONTRIBUTING.md README.md  )

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
