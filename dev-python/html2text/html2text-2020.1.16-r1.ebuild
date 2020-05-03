# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( pypy3 python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Turn HTML into equivalent Markdown-structured text"
HOMEPAGE="https://github.com/Alir3z4/html2text https://pypi.org/project/html2text/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~sparc x86"

DOCS=( AUTHORS.rst ChangeLog.rst README.md )

distutils_enable_tests pytest

python_prepare_all() {
	# naming conflict with app-text/html2text, bug 421647
	sed -i 's/html2text = html2text.cli:main/py\0/' setup.cfg || die
	distutils-r1_python_prepare_all
}
