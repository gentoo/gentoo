# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Support library for building plugins systems in Python"
HOMEPAGE="
	https://github.com/mitsuhiko/pluginbase/
	https://pypi.org/project/pluginbase/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

distutils_enable_sphinx docs
distutils_enable_tests pytest

src_test() {
	cd tests || die
	distutils-r1_src_test
}
