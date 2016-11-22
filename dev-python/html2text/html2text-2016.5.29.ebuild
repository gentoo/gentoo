# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} pypy )

inherit distutils-r1

DESCRIPTION="Turn HTML into equivalent Markdown-structured text"
HOMEPAGE="https://github.com/html2text/html2text
	https://github.com/Alir3z4/html2text https://pypi.python.org/pypi/html2text"
SRC_URI="https://github.com/Alir3z4/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${CDEPEND}
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/feedparser[${PYTHON_USEDEP}]"
DEPEND="${CDEPEND}"

DOCS=( AUTHORS.rst ChangeLog.rst README.md )

src_prepare() {
	default

	# naming conflict with app-text/html2text, bug 421647
	sed -i 's/html2text=html2text.cli:main/py\0/' setup.py || die
}

python_test() {
	"${PYTHON}" test/test_html2text.py -v || die "tests failed with ${EPYTHON}"
}
