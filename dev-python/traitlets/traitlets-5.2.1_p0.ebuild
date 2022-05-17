# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

MY_P=${P/_p/.post}
DESCRIPTION="A configuration system for Python applications"
HOMEPAGE="
	https://github.com/ipython/traitlets/
	https://pypi.org/project/traitlets/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

distutils_enable_sphinx docs/source \
	dev-python/sphinx_rtd_theme
distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
