# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="Copy-on-write locking mechanism for expensive resources"
HOMEPAGE="https://bitbucket.org/zzzeek/dogpile.core"
SRC_URI="mirror://pypi/${PN:0:1}/dogpile.core/dogpile.core-${PV}.tar.gz"
S="${WORKDIR}/dogpile.core-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (	dev-python/nose[${PYTHON_USEDEP}] )"
RDEPEND=""

python_test() {
	nosetests tests/ || die "test failed under ${EPYTHON}"
}
