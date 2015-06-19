# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/simpleeval/simpleeval-0.8.5.ebuild,v 1.1 2015/06/09 08:21:46 cedk Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="A simple, safe single expression evaluator library"
HOMEPAGE="https://github.com/danthedeckie/simpleeval"
SRC_URI="mirror://pypi/s/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	${DEPEND}
	dev-python/setuptools"

DOCS="README.rst"

python_test() {
	esetup.py test || die
}
