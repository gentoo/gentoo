# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=(python{2_7,3_4})

inherit distutils-r1

DESCRIPTION="Friendlier RFC 6265-compliant cookie parser/renderer"
HOMEPAGE="https://gitlab.com/sashahart/cookies"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="test? ( dev-python/pytest[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	py.test || die
}
