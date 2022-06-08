# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit_scm
PYTHON_COMPAT=( pypy3 python3_{8..10} )

inherit distutils-r1

MY_P=${P/_}
DESCRIPTION="Backport of PEP 654 (exception groups)"
HOMEPAGE="
	https://github.com/agronholm/exceptiongroup/
	https://pypi.org/project/exceptiongroup/
"
SRC_URI="
	https://github.com/agronholm/exceptiongroup/archive/${PV/_}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT PSF-2.4"
SLOT="0"
KEYWORDS="~amd64 ~x86"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV/_}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
