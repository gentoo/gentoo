# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} )

inherit distutils-r1

DESCRIPTION="Reusable Django field that allows you to store validated JSON in your model"
HOMEPAGE="https://pypi.python.org/pypi/jsonfield https://github.com/bradjasper/django-jsonfield"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND=""
DEPEND="test? ( dev-python/django[${PYTHON_USEDEP}] )"

python_test() {
	esetup.py test
}
