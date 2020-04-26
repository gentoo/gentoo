# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Simple static web gallery generator"
HOMEPAGE="https://sigal.saimon.org/"
SRC_URI="https://github.com/saimn/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="brotli crypt rss s3 test zopfli"
RESTRICT="!test? ( test )"

CDEPEND="dev-python/blinker[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pilkit[${PYTHON_USEDEP}]
	dev-python/natsort[${PYTHON_USEDEP}]"
DEPEND="${CDEPEND}
	brotli? ( app-arch/brotli[${PYTHON_USEDEP}] )
	crypt? ( dev-python/cryptography[${PYTHON_USEDEP}] )
	rss? ( dev-python/feedgenerator[${PYTHON_USEDEP}] )
	s3? ( dev-python/boto[${PYTHON_USEDEP}] )
	test? (
		dev-python/boto[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
	zopfli? ( app-arch/zopfli )"
RDEPEND="${CDEPEND}"

DOCS="README.rst"

python_test() {
	esetup.py test
}
