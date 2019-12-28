# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy{,3} python{2_7,3_{5,6,7,8}} )

inherit distutils-r1

DESCRIPTION="A python interface to the sendfile(2) system call"
HOMEPAGE="https://github.com/giampaolo/pysendfile"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 ~s390 sparc x86"
IUSE=""
LICENSE="MIT"
SLOT="0"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	"${EPYTHON}" test/test_sendfile.py || die "tests failed with ${EPYTHON}"
}
