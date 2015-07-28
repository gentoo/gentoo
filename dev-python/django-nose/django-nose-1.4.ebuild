# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/django-nose/django-nose-1.4.ebuild,v 1.2 2015/07/28 05:28:25 patrick Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

RESTRICT="test" # missing south now

inherit distutils-r1

DESCRIPTION="Django test runner that uses nose"
HOMEPAGE="https://github.com/jbalogh/django-nose"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=dev-python/nose-1.2.1[${PYTHON_USEDEP}]
		dev-python/django[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
#	test? ( ${RDEPEND}
#		>=dev-python/south-0.7[${PYTHON_USEDEP}] )"

python_test() {
	"${PYTHON}" testapp/runtests.py
}
