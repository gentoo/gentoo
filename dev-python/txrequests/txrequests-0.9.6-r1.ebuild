# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Asynchronous Python HTTP for Humans"
HOMEPAGE="
	https://github.com/tardyp/txrequests/
	https://pypi.org/project/txrequests/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv ~x86"
IUSE="test"
PROPERTIES="test_network"
RESTRICT="test"

RDEPEND="
	>=dev-python/requests-1.2.0[${PYTHON_USEDEP}]
	dev-python/twisted[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
	)
"

python_test() {
	"${EPYTHON}" -m twisted.trial test_txrequests ||
		die "Tests failed for ${EPYTHON}"
}
