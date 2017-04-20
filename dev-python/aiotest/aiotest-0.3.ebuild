# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 python3_5 python3_6 )
inherit distutils-r1

DESCRIPTION="Test suite for an implementation of asyncio (PEP 3156)"
HOMEPAGE="https://bitbucket.org/haypo/aiotest"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	$(python_gen_cond_dep 'dev-python/trollius[${PYTHON_USEDEP}]' python2_7)
	$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7)"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	local suite
	python_is_python3 && suite=asyncio || suite=trollius
	"${PYTHON}" "test_${suite}.py" || die "Tests fail with ${EPYHON} (${suite})"
}
