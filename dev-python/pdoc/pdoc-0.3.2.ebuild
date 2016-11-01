# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1

DESCRIPTION="Simple program and library to auto generate API documentation for Python modules"
HOMEPAGE="https://pypi.python.org/pypi/pdoc https://github.com/BurntSushi/pdoc"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="Unlicense"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/mako[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

python_prepare_all() {
	# Markdown < 2.5 is only for Python 2.6 support, which we don't support
	sed \
		-e "s|markdown < 2.5|markdown|" \
		-e "s|share/pdoc|share/doc/${PF}|" \
		-e "s|'UNLICENSE', ||" \
		-i setup.py || die "sed failed"

	distutils-r1_python_prepare_all
}
