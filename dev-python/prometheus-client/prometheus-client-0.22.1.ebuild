# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1

MY_P=client_python-${PV}
DESCRIPTION="Python client for the Prometheus monitoring system"
HOMEPAGE="
	https://github.com/prometheus/client_python/
	https://pypi.org/project/prometheus-client/
"
# missing test data in sdist
# https://github.com/prometheus/client_python/issues/1112
SRC_URI="
	https://github.com/prometheus/client_python/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	dev-python/twisted[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_IGNORE=(
		# optional tests, broken with >=dev-python/asgiref-3.8
		tests/test_asgi.py
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
