# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_4} pypy )
inherit distutils-r1

DESCRIPTION="Django recaptcha form field/widget app"
HOMEPAGE="https://github.com/praekelt/django-recaptcha https://pypi.python.org/pypi/django-recaptcha"
#SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
SRC_URI="https://github.com/praekelt/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-python/django[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		>=dev-python/django-setuptest-0.2.1[${PYTHON_USEDEP}] )"

python_test() {
	esetup.py test
}
