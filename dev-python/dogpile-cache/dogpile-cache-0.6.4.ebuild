# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="A locking API for expiring values while a single thread generates a new value."
HOMEPAGE="https://bitbucket.org/zzzeek/dogpile.cache"
SRC_URI="mirror://pypi/${PN:0:1}/dogpile.cache/dogpile.cache-${PV}.tar.gz"
S="${WORKDIR}/dogpile.cache-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		test? ( dev-python/pytest[${PYTHON_USEDEP}]
				dev-python/pytest-cov[${PYTHON_USEDEP}]
				dev-python/mock[${PYTHON_USEDEP}]
				dev-python/mako[${PYTHON_USEDEP}] )"

# This time half the doc files are missing; Do you want them? toss a coin

python_test() {
	"${EPYTHON}" ./setup.py test || die "test failed under ${EPYTHON}"
}
