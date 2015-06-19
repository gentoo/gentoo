# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/dogpile-cache/dogpile-cache-0.5.1.ebuild,v 1.1 2013/10/22 04:35:03 prometheanfire Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="The Oslo configuration API supports parsing command line arguments
and ini style configuration files"
HOMEPAGE="https://bitbucket.org/zzzeek/dogpile.cache"
SRC_URI="mirror://pypi/${PN:0:1}/dogpile.cache/dogpile.cache-${PV}.tar.gz"
S="${WORKDIR}/dogpile.cache-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		>=dev-python/dogpile-core-0.4.1[${PYTHON_USEDEP}]
	test? ( dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}] )"
RDEPEND=""

# This time half the doc files are missing; Do you want them?

python_test() {
	nosetests || die "test failed under ${EPYTHON}"
}
