# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/queuelib/queuelib-1.1.1.ebuild,v 1.5 2015/03/08 23:57:49 pacho Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 python3_3 python3_4 )

inherit vcs-snapshot distutils-r1

DESCRIPTION="Collection of persistent (disk-based) queues"
HOMEPAGE="https://github.com/scrapy/${PN}"
SRC_URI="https://github.com/scrapy/${PN}/archive/v${PV}.tar.gz -> ${PN}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

S="${WORKDIR}/${PN}"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
	)"

RDEPEND=""

python_test() {
	nosetests queuelib/tests/ || die "Tests failed under ${EPYTHON}"
}
