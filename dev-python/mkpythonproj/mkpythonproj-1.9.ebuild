# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/mkpythonproj/mkpythonproj-1.9.ebuild,v 1.1 2014/08/13 03:20:05 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

DESCRIPTION="Creates the framework for a new Python project or script"
HOMEPAGE="http://www.seanet.com/~hgg9140/comp/mkpythonproj/doc/index.html"
SRC_URI="http://www.seanet.com/~hgg9140/comp/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

python_install_all() {
	use doc && local HTML_DOCS=( doc/. )
	distutils-r1_python_install_all
}
