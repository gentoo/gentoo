# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )
inherit distutils-r1

DESCRIPTION="Add Python and JavaScript style comments in your JSON files"
HOMEPAGE="
	https://pypi.org/project/commentjson/
	https://github.com/vaidik/commentjson/"
SRC_URI="
	https://github.com/vaidik/commentjson/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

RDEPEND="
	dev-python/lark-parser[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/six[${PYTHON_USEDEP}]
	)"

distutils_enable_tests unittest

src_prepare() {
	# remove unnecessary version bind
	sed -i -e '/lark-parser/s:,<0.8.0::' setup.py || die
	distutils-r1_src_prepare
}
