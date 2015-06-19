# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/hachoir-regex/hachoir-regex-1.0.5-r1.ebuild,v 1.4 2015/03/08 23:49:58 pacho Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Manipulation of regular expressions (regex)"
HOMEPAGE="http://bitbucket.org/haypo/hachoir/wiki/hachoir-regex http://pypi.python.org/pypi/hachoir-regex"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

python_configure_all() {
	mydistutilsargs=(
		--setuptools
	)
}

python_test() {
	"${PYTHON}" test_doc.py || die "Tests fail with ${EPYTHON}"
}
