# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1

MY_P=sigstore-python-${PV}
DESCRIPTION="A tool for signing Python package distributions"
HOMEPAGE="
	https://github.com/sigstore/sigstore-python/
	https://pypi.org/project/sigstore/
"
# no tests in sdist, as of 3.3.0
SRC_URI="
	https://github.com/sigstore/sigstore-python/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64"

RDEPEND="
	>=dev-python/cryptography-42[${PYTHON_USEDEP}]
	>=dev-python/id-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-4.2[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-23.0.0[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-0.6[${PYTHON_USEDEP}]
	>=dev-python/pydantic-2[${PYTHON_USEDEP}]
	>=dev-python/pyjwt-2.1[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	~dev-python/rfc3161-client-1.0.3[${PYTHON_USEDEP}]
	>=dev-python/rfc8785-0.1.2[${PYTHON_USEDEP}]
	>=dev-python/rich-13[${PYTHON_USEDEP}]
	~dev-python/sigstore-models-0.0.6[${PYTHON_USEDEP}]
	~dev-python/sigstore-rekor-types-0.0.18[${PYTHON_USEDEP}]
	>=dev-python/tuf-6.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pretend[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# unpin deps
	sed -r -i -e 's:~=:>=:' -e 's:, ?< ?[0-9.]*::' pyproject.toml || die
}

python_test() {
	epytest test/unit --skip-online
}
