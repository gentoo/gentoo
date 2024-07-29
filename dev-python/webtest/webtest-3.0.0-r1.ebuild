# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN="WebTest"
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Helper to test WSGI applications"
HOMEPAGE="
	https://docs.pylonsproject.org/projects/webtest/en/latest/
	https://github.com/Pylons/webtest/
	https://pypi.org/project/WebTest/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

RDEPEND="
	dev-python/paste[${PYTHON_USEDEP}]
	dev-python/pastedeploy[${PYTHON_USEDEP}]
	>=dev-python/webob-1.2[${PYTHON_USEDEP}]
	>=dev-python/waitress-0.8.5[${PYTHON_USEDEP}]
	dev-python/beautifulsoup4[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pyquery[${PYTHON_USEDEP}]
		dev-python/wsgiproxy2[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/legacy-cgi[${PYTHON_USEDEP}]
		' 3.13)
	)
"

PATCHES=(
	"${FILESDIR}/webtest-2.0.33-no-pylons-theme.patch"
	"${FILESDIR}/webtest-3.0.0-python3.12-unittest.patch"
)

distutils_enable_sphinx docs
distutils_enable_tests pytest
