# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="In-process task scheduler with Cron-like capabilities"
HOMEPAGE="https://bitbucket.org/agronholm/apscheduler"
SRC_URI="mirror://pypi/A/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/six-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/tzlocal-1.2[${PYTHON_USEDEP}]
	virtual/python-funcsigs[${PYTHON_USEDEP}]
	virtual/python-futures[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-capturelog[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	sed -i -e /setuptools_scm/d setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	# 3 known failures due to caplog.set_level not existing
	py.test || die "Testing failed with ${EPYTHON}"
}
