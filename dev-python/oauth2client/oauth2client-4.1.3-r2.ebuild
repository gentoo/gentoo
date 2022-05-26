# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Library for accessing resources protected by OAuth 2.0"
HOMEPAGE="https://github.com/googleapis/oauth2client"
SRC_URI="https://github.com/googleapis/oauth2client/archive/v${PV/_p/-post}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${P/_p/-post}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/httplib2-0.9.1[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-0.1.7[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-modules-0.0.5[${PYTHON_USEDEP}]
	>=dev-python/rsa-3.1.4[${PYTHON_USEDEP}]
	>=dev-python/six-1.6.1[${PYTHON_USEDEP}]
	dev-python/keyring[${PYTHON_USEDEP}]
	!<=dev-python/google-api-python-client-1.1[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/flask[${PYTHON_USEDEP}]
		dev-python/sqlalchemy[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests nose

PATCHES=(
	"${FILESDIR}/oauth2client-4.1.3-py38.patch"
)

python_test() {
	nosetests -v \
		-e appengine \
		-e django_util \
		-e test_multiprocess_file_storage \
		-e test_bad_positional || die "tests fail with ${EPYTHON}"
	# appengine - requires appengine
	# django_util - requires django
	# test_multiprocess_file_storage - requires fasteners
	# test_bad_positional - expects TypeError, gets ValueError
}
