# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Code Metrics in Python"
HOMEPAGE="
	https://radon.readthedocs.io/
	https://github.com/rubik/radon/
	https://pypi.org/project/radon/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	>=dev-python/colorama-0.4.1[${PYTHON_USEDEP}]
	dev-python/flake8[${PYTHON_USEDEP}]
	>=dev-python/mando-0.6[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs
EPYTEST_PLUGINS=( pytest-mock )
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# unpin deps
	sed -i -e 's:,<[0-9.]*::' pyproject.toml || die
}
