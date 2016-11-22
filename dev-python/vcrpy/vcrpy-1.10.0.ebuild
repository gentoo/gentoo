# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5} pypy )

inherit distutils-r1

DESCRIPTION="Automatically mock your HTTP interactions to simplify and speed up testing"
HOMEPAGE="https://github.com/kevin1024/vcrpy"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
#SRC_URI="https://github.com/kevin1024/vcrpy/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-python/contextlib2[${PYTHON_USEDEP}]
	>=dev-python/httplib2-0.9.1[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	>=dev-python/six-1.5[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]
	dev-python/wrapt[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7)
	$(python_gen_cond_dep 'dev-python/contextlib2[${PYTHON_USEDEP}]' python2_7)
	"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-httpbin[${PYTHON_USEDEP}]
	)"

# Calls to the net
RESTRICT=test

python_test() {
	py.test -vv -x || die
}
