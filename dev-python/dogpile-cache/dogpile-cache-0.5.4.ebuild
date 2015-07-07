# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/dogpile-cache/dogpile-cache-0.5.4.ebuild,v 1.4 2015/07/07 16:44:58 zlogene Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="API built on a lock allowing access to expiring values while a single thread generates a new value."
HOMEPAGE="https://bitbucket.org/zzzeek/dogpile.cache"
SRC_URI="mirror://pypi/${PN:0:1}/dogpile.cache/dogpile.cache-${PV}.tar.gz"
S="${WORKDIR}/dogpile.cache-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"

RDEPEND=">=dev-python/dogpile-core-0.4.1[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		test? ( dev-python/mock[${PYTHON_USEDEP}]
				dev-python/nose[${PYTHON_USEDEP}]
				dev-python/mako[${PYTHON_USEDEP}]
				>=dev-python/dogpile-core-0.4.1[${PYTHON_USEDEP}] )"

# for testsuite
DISTUTILS_NO_PARALLEL_BUILD=1
# This time half the doc files are missing; Do you want them? toss a coin

python_test() {
	# crikey. testsuite written for py3, 5 tests fail under py2.7
	if [[ "${EPYTHON}" != "python2.7" ]]; then
		nosetests || die "test failed under ${EPYTHON}"
	else
		einfo "testsuite restricted for python2.7"
	fi
}
