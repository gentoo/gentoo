# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pudge/pudge-0.1.3-r1.ebuild,v 1.4 2015/04/08 08:05:20 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A documentation generator for Python projects, using Restructured Text"
HOMEPAGE="http://pudge.lesscode.org http://pypi.python.org/pypi/pudge"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

RDEPEND="dev-python/docutils[${PYTHON_USEDEP}]
	>=dev-python/kid-0.9.5[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( ${RDEPEND} )"

python_compile_all() {
	if use doc; then
		einfo "Generation of documentation"
		"${PYTHON}" bin/pudge --modules=pudge --documents=doc/index.rst --dest=doc/html \
		|| die "Generation of documentation failed"
	fi
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/html/. )
	distutils-r1_python_install_all
}
