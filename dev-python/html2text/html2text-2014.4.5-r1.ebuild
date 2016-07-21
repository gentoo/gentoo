# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Turn HTML into equivalent Markdown-structured text"
HOMEPAGE="https://github.com/html2text/html2text
	https://github.com/Alir3z4/html2text https://pypi.python.org/pypi/html2text"
SRC_URI="https://github.com/Alir3z4/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="dev-python/chardet[${PYTHON_USEDEP}]
		dev-python/feedparser[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND} )"

PATCHES=( "${FILESDIR}/${PN}-rename.patch"
	"${FILESDIR}/${PN}-noinstall-test.patch" )

python_test() {
	"${PYTHON}" test/test_html2text.py -v || die
}
