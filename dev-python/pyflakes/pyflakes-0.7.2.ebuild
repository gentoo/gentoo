# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyflakes/pyflakes-0.7.2.ebuild,v 1.8 2015/04/08 08:05:13 mgorny Exp $

EAPI=5
PYTHON_COMPAT=(python{2_7,3_3} )

inherit distutils-r1

DESCRIPTION="Passive checker for Python programs"
HOMEPAGE="https://launchpad.net/pyflakes http://pypi.python.org/pypi/pyflakes"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux ~arm-linux ~x86-linux ~x86-macos"
IUSE="test"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/unittest2[${PYTHON_USEDEP}] )"

python_test() {
	# a known failure of 1 test in py3.2.4
	# https://bugs.launchpad.net/pyflakes/+bug/1172463
	esetup.py test --quiet
}
