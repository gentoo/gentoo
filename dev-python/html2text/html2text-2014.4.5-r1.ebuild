# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/html2text/html2text-2014.4.5-r1.ebuild,v 1.7 2015/04/19 07:02:14 pacho Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Turn HTML into equivalent Markdown-structured text"
HOMEPAGE="https://github.com/html2text/html2text
	https://github.com/Alir3z4/html2text http://pypi.python.org/pypi/html2text"
SRC_URI="https://github.com/Alir3z4/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"  # PyPI one missing test data files

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/feedparser[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${PN}-rename.patch"
	"${FILESDIR}/${PN}-noinstall-test.patch" )

src_test() {
	impl_specific() {
		python_export PYTHON_SITEDIR
		PYTHONPATH="${D}${PYTHON_SITEDIR}" "${PYTHON}" test/test_html2text.py -v || die
	}
	python_foreach_impl impl_specific
}
