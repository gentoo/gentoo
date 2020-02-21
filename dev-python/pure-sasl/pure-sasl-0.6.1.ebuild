# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_7 )
inherit distutils-r1

DESCRIPTION="High-level SASL client written in pure Python"
HOMEPAGE="https://github.com/thobbs/pure-sasl"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
		$(python_gen_cond_dep dev-python/unittest2 'python2*')
	)"

# tests aren't in dist tarball
RESTRICT="test"

python_test() {
	nosetests -v || die
}
