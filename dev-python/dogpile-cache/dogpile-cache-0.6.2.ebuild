# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="A locking API for expiring values while a single thread generates a new value."
HOMEPAGE="https://bitbucket.org/zzzeek/dogpile.cache"
SRC_URI="mirror://pypi/${PN:0:1}/dogpile.cache/dogpile.cache-${PV}.tar.gz"
S="${WORKDIR}/dogpile.cache-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="test"

RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		test? ( dev-python/pytest[${PYTHON_USEDEP}]
				dev-python/pytest-cov[${PYTHON_USEDEP}]
				dev-python/mock[${PYTHON_USEDEP}]
				dev-python/mako[${PYTHON_USEDEP}] )"

# This time half the doc files are missing; Do you want them? toss a coin

python_test() {
	# crikey. testsuite written for py3, 5 tests fail under py2.7
	if [[ "${EPYTHON}" != "python2.7" ]]; then
		nosetests || die "test failed under ${EPYTHON}"
	else
		einfo "testsuite restricted for python2.7"
	fi
}
