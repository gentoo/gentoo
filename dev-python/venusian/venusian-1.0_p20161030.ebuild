# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{5,6} )

COMMIT="ec4032596e3aec987ba29b62cac701608ef3b523"

inherit distutils-r1

DESCRIPTION="A library for deferring decorator actions"
HOMEPAGE="http://www.pylonsproject.org/"
#SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
SRC_URI="https://github.com/Pylons/venusian/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="repoze"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}]
		>=dev-python/nose-exclude-0.1.9[${PYTHON_USEDEP}] )
	"

S="${WORKDIR}/${PN}-${COMMIT}"

python_test() {
	# copy the zipfile to the fixtures dir, setup.py doesn't
	cp "${S}"/venusian/tests/fixtures/zipped.zip "${BUILD_DIR}"/lib/venusian/tests/fixtures/ || die "Failed to cp zipfile.zip"

	cd "${BUILD_DIR}/lib/venusian"
	nosetests --exclude-dir=tests/fixtures || die "Tests fail with ${EPYTHON}"
}
