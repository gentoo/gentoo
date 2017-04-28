# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1

DESCRIPTION="Python parser for the CommonMark Markdown spec"
HOMEPAGE="https://github.com/rtfd/CommonMark-py"
LICENSE="BSD"

SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

IUSE=""
RDEPEND="
	dev-python/future[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/hypothesis[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"

# unrestrict for versions >= 0.7.2
RESTRICT=test

python_test() {
	LC_ALL='en_US.utf8' LC_CTYPE='en_US.utf8' LANG=en_US.utf8 PYTHONIOENCODING=UTF-8 \
		  esetup.py test
}
