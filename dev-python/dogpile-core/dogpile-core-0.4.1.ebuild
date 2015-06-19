# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/dogpile-core/dogpile-core-0.4.1.ebuild,v 1.5 2015/04/08 08:05:21 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 python3_3 python3_4 )

inherit distutils-r1

DESCRIPTION="A lock which allows a thread to generate an expensive resource while other threads use the old value"
HOMEPAGE="https://bitbucket.org/zzzeek/dogpile.core"
SRC_URI="mirror://pypi/${PN:0:1}/dogpile.core/dogpile.core-${PV}.tar.gz"
S="${WORKDIR}/dogpile.core-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (	dev-python/nose[${PYTHON_USEDEP}] )"
RDEPEND=""

python_test() {
	nosetests tests/ || die "test failed under ${EPYTHON}"
}
