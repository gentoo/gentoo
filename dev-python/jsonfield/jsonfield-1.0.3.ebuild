# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/jsonfield/jsonfield-1.0.3.ebuild,v 1.1 2015/02/24 07:24:16 jlec Exp $

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
