# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN=${PN/-/.}
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Additional facilities to supplement Python's stdlib logging module"
HOMEPAGE="
	https://github.com/jaraco/jaraco.logging/
	https://pypi.org/project/jaraco.logging/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv x86"

RDEPEND="
	dev-python/tempora[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools-scm-1.15.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	# create a pkgutil-style __init__.py in order to fix pytest's
	# determination of package paths
	cat > jaraco/__init__.py <<-EOF || die
		__path__ = __import__("pkgutil").extend_path(__path__, __name__)
	EOF
	epytest --doctest-modules
}
