# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Spotify Web API client"
HOMEPAGE="
	https://tekore.readthedocs.io/
	https://github.com/felix-hilden/tekore/
	https://pypi.org/project/tekore/
"
SRC_URI="
	https://github.com/felix-hilden/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"

RDEPEND="
	<dev-python/httpx-0.24[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		>=dev-python/pytest-asyncio-0.17[${PYTHON_USEDEP}]
	)
"

DOCS=( readme.rst )

distutils_enable_tests pytest
# TODO: package sphinx_codeautolink
# distutils_enable_sphinx docs/src \
# 	dev-python/sphinx_rtd_theme \
# 	dev-python/sphinx-tabs \
# 	dev-python/sphinx-autodoc-typehints

EPYTEST_DESELECT=(
	# Internet
	tests/auth/expiring.py::TestCredentialsOnline::test_bad_arguments_raises_error
)
