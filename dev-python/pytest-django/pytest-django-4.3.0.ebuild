# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} pypy3 )

inherit distutils-r1

DESCRIPTION="A Django plugin for py.test"
HOMEPAGE="
	https://pypi.org/project/pytest-django/
	https://pytest-django.readthedocs.io/
	https://github.com/pytest-dev/pytest-django/"
SRC_URI="
	https://github.com/pytest-dev/pytest-django/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="BSD"
KEYWORDS="amd64 arm arm64 ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
SLOT="0"

RDEPEND="
	>=dev-python/pytest-5.4[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	>=dev-python/setuptools_scm-1.11.1[${PYTHON_USEDEP}]
"

# not all test dependencies are packaged and this package isn't worth it.
RESTRICT="test"

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
