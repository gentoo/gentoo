# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

DESCRIPTION="Ultra fast JSON encoder and decoder for Python"
HOMEPAGE="https://pypi.org/project/ujson/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"

BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? ( dev-python/pytz[${PYTHON_USEDEP}] )
"

distutils_enable_tests pytest

src_prepare() {
	# Don't manually strip files
	sed -e '/extra_link_args/s/strip_flags/\[\]/' -i setup.py || die

	distutils-r1_src_prepare
}
