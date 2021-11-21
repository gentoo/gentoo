# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Common humanization utilities"
HOMEPAGE="https://github.com/jmoiron/humanize/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? ( dev-python/freezegun[${PYTHON_USEDEP}] )
"

distutils_enable_tests --install pytest

src_prepare() {
	sed -e '/setuptools/d' -i setup.cfg || die
	distutils-r1_src_prepare
}
