# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Accurately separate the TLD from the registered domain and subdomains of a URL"
HOMEPAGE="
	https://github.com/john-kurkowski/tldextract/
	https://pypi.org/project/tldextract/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~x86"

RDEPEND="
	>=dev-python/filelock-3.0.8[${PYTHON_USEDEP}]
	dev-python/idna[${PYTHON_USEDEP}]
	>=dev-python/requests-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/requests-file-1.4[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/responses[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# we don't need release tests, also deps
	tests/test_release.py
)
