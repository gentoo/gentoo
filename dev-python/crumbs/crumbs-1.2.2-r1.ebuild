# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/crumbs/crumbs-1.2.2-r1.ebuild,v 1.2 2015/04/08 08:05:26 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 python3_3 )

inherit distutils-r1

DESCRIPTION="Generalized all-in-one parameters module"
HOMEPAGE="https://github.com/alunduil/crumbs"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="inotify test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)
"
RDEPEND="inotify? ( dev-python/pyinotify[${PYTHON_USEDEP}] )"

python_test() {
	flake8 || die 'flake8'
	nosetests || die 'nosetests'
}
