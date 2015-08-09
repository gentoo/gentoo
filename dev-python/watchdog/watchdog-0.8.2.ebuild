# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy)

inherit distutils-r1 eutils

DESCRIPTION="Python API and shell utilities to monitor file system events"
HOMEPAGE="http://github.com/gorakhargosh/watchdog"
SRC_URI="mirror://pypi/w/watchdog/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

CDEPEND="dev-python/pyyaml[${PYTHON_USEDEP}]"
RDEPEND="${CDEPEND}
	dev-python/argh[${PYTHON_USEDEP}]
	dev-python/pathtools[${PYTHON_USEDEP}]"
DEPEND="${CDEPEND}
	test? (
		dev-python/pytest
		dev-python/pytest-cov
		>=dev-python/pytest-timeout-0.3
		)"

python_test() {
	esetup.py test
}

pkg_postinst() {
	optfeature "Bash completion" dev-python/argcomplete
}
