# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/django-nose/django-nose-1.4.1.ebuild,v 1.1 2015/08/05 05:32:16 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Django test runner that uses nose"
HOMEPAGE="https://github.com/jbalogh/django-nose"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="test"  # The testsuite currently broken See notes below

RDEPEND=">=dev-python/nose-1.2.1[${PYTHON_USEDEP}]
		dev-python/django[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
#	test? ( ${RDEPEND}
#		>=dev-python/south-0.7[${PYTHON_USEDEP}] )"
# South currently doesn't support any versions of django in portage
# that support python3. They are masked as is south which appears may be deprecated

python_test() {
	# https://github.com/django-nose/django-nose/issues/227
	# Running tests by the bash script runtests.sh reveals a missing
	# folder. Use of runtests.py works only for py2.7 due to
	# south supporting only old versions of django.
	# The testsuite has a massive rewrite set in the issue listed above.
	./runtests.sh
#	"${PYTHON}" testapp/runtests.py broken
}
