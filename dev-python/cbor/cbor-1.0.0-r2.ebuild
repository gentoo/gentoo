# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

EGIT_COMMIT="b3af679e7cf3e12d50acb83c3c591fc5db9a658d"
DESCRIPTION="RFC 7049 - Concise Binary Object Representation"
HOMEPAGE="
	https://github.com/brianolson/cbor_py/
	https://pypi.org/project/cbor/
"
SRC_URI="
	https://github.com/brianolson/cbor_py/archive/${EGIT_COMMIT}.tar.gz
		-> ${P}.gh.tar.gz
"
S=${WORKDIR}/cbor_py-${EGIT_COMMIT}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"

# upstream PR: https://github.com/brianolson/cbor_py/pull/19
# upstream PR: https://github.com/brianolson/cbor_py/pull/11
PATCHES=(
	"${FILESDIR}/cbor-1.0.0.zero-length-bytes.patch"
	"${FILESDIR}/cbor-1.0.0.Fix-broken-test_sortkeys.patch"
	"${FILESDIR}/cbor-1.0.0.Replace-deprecated-logger.warn.patch"
)

python_test() {
	"${EPYTHON}" cbor/tests/test_cbor.py    || die "Testsuite failed under ${EPYTHON}"
	"${EPYTHON}" cbor/tests/test_objects.py || die "Testsuite failed under ${EPYTHON}"
	"${EPYTHON}" cbor/tests/test_usage.py   || die "Testsuite failed under ${EPYTHON}"
	"${EPYTHON}" cbor/tests/test_vectors.py || die "Testsuite failed under ${EPYTHON}"
}
