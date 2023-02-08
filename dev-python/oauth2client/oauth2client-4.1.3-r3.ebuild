# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Library for accessing resources protected by OAuth 2.0"
HOMEPAGE="https://github.com/googleapis/oauth2client"
SRC_URI="
	https://github.com/googleapis/oauth2client/archive/v${PV/_p/-post}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~robbat2/distfiles/oauth2client-4.1.3-fixes-20230207.patch
	"
S="${WORKDIR}"/${P/_p/-post}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"

# This package supports 3 different crypto options, but tests ALL of them
CRYPTO_A=">=dev-python/pycryptodome-2.6[${PYTHON_USEDEP}]"
CRYPTO_B="dev-python/pyopenssl[${PYTHON_USEDEP}]"
CRYPTO_C="(
	>=dev-python/pyasn1-0.1.7[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-modules-0.0.5[${PYTHON_USEDEP}]
	>=dev-python/rsa-3.1.4[${PYTHON_USEDEP}]
	)"

RDEPEND="
	>=dev-python/httplib2-0.9.1[${PYTHON_USEDEP}]
	>=dev-python/six-1.6.1[${PYTHON_USEDEP}]
	|| ( ${CRYPTO_A} ${CRYPTO_B} ${CRYPTO_C} )
	dev-python/keyring[${PYTHON_USEDEP}]
	!<=dev-python/google-api-python-client-1.1[${PYTHON_USEDEP}]
"

# Not well-tested upstream, and broken:
# django dev-python/django[${PYTHON_USEDEP}]
# flask dev-python/flask[${PYTHON_USEDEP}]
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/sqlalchemy[${PYTHON_USEDEP}]
		dev-python/fasteners[${PYTHON_USEDEP}]
		${CRYPTO_A}
		${CRYPTO_B}
		${CRYPTO_C}
	)
"

distutils_enable_tests pytest

PATCHES=(
	"${DISTDIR}/oauth2client-4.1.3-fixes-20230207.patch"
)

src_prepare() {
	default
	# These contrib modules are broken upstream:
	REMOVE=(
		# django
		"${S}"/oauth2client/contrib/django_util/
		"${S}"/samples/django/
		"${S}"/tests/contrib/django_util/
		"${S}"/docs/source/oauth2client.contrib.django*
		# flask
		"${S}"/docs/source/oauth2client.contrib.flask_util.rst
		"${S}"/oauth2client/contrib/flask_util.py
		"${S}"/tests/contrib/test_flask_util.py
	)
	rm -rf "${REMOVE[@]}"
}

python_test() {
	TEST_ARGS=(
		# appengine - requires appengine
		# django_util - requires django, contrib module broken upstream
		# flash - requires flask, contrib module broken upstream
		--ignore-glob='*appengine*'
	)
	epytest "${TEST_ARGS[@]}" || die "tests fail with ${EPYTHON}"
}
