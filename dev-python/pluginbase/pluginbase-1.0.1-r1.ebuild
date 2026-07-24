# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Support library for building plugins systems in Python"
HOMEPAGE="
	https://github.com/mitsuhiko/pluginbase/
	https://pypi.org/project/pluginbase/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"

distutils_enable_sphinx docs
EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_test() {
	cd tests || die
	distutils-r1_src_test
}
