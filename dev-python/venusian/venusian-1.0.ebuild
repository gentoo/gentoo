# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/venusian/venusian-1.0.ebuild,v 1.4 2015/04/08 08:05:15 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

#RESTRICT="test"

inherit distutils-r1

DESCRIPTION="A library for deferring decorator actions"
HOMEPAGE="http://www.pylonsproject.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="repoze"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="
	"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}]
		~dev-python/nose-exclude-0.1.9[${PYTHON_USEDEP}] )
	"

python_test() {
	nosetests || die "Tests fail with ${EPYTHON}"
}
