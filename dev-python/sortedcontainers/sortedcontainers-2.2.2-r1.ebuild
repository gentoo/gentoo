# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8,9} pypy3 )

inherit distutils-r1

MY_P=python-${P}
DESCRIPTION="Python library to sort collections and containers"
HOMEPAGE="http://www.grantjenks.com/docs/sortedcontainers/
	https://pypi.org/project/sortedcontainers/
	https://github.com/grantjenks/python-sortedcontainers/"
SRC_URI="
	https://github.com/grantjenks/python-sortedcontainers/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

distutils_enable_tests pytest

python_test() {
	local -x PYTHONPATH=.
	pytest -vv --ignore docs/conf.py || die "Tests fail with ${EPYTHON}"
}
