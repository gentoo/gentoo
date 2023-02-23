# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 pypi

DESCRIPTION="Reliable Asynchronous Event Transport Protocol"
HOMEPAGE="
	https://github.com/RaetProtocol/raet/
	https://pypi.org/project/raet/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/six-1.6.1[${PYTHON_USEDEP}]
	>=dev-python/libnacl-1.4.3[${PYTHON_USEDEP}]
	>=dev-python/ioflo-2.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/msgpack-1.0.0[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/raet-0.6.8-msgpack-1.0.patch"
	"${FILESDIR}/raet-0.6.8-py310.patch"
)

python_prepare_all() {
	distutils-r1_python_prepare_all
	sed -e "/setuptools_git/d" -i setup.py || die
}

python_test() {
	cd "${BUILD_DIR}/install$(python_get_sitedir)" || die
	"${EPYTHON}" raet/test/__init__.py || die "tests failed for ${EPYTHON}"
}
