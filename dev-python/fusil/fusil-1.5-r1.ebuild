# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy )

inherit distutils-r1 user

DESCRIPTION="Python library to write fuzzing programs"
HOMEPAGE="https://bitbucket.org/haypo/fusil/wiki/Home https://pypi.org/project/fusil/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

DEPEND="doc? ( dev-python/docutils[${PYTHON_USEDEP}] )"
RDEPEND=">=dev-python/python-ptrace-0.7[${PYTHON_USEDEP}]"

python_compile_all() {
	use doc && emake -C doc RST2HTML="rst2html.py"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/. )
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}

pkg_postinst() {
	enewgroup "${PN}"
	enewuser "${PN}" -1 -1 -1 "${PN}"
}
