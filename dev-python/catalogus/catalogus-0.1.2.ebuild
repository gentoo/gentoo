# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/breezy-team/catalogus
PYTHON_COMPAT=( python3_1{2..5} )

inherit distutils-r1 pypi

DESCRIPTION="Classes to provide name-to-object registry-like support"
HOMEPAGE="https://pypi.org/project/catalogus/ https://github.com/breezy-team/catalogus"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_prepare() {
	default
	sed -e '/--cov/d' -i pyproject.toml || die
}

python_test() {
	epytest tests
}
