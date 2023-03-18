# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Asynchronous Python HTTP for Humans"
HOMEPAGE="https://github.com/tardyp/txrequests"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/requests-1.2.0[${PYTHON_USEDEP}]
	dev-python/twisted[${PYTHON_USEDEP}]
"
BDEPEND="test? ( ${RDEPEND} )"

python_test() {
	"${EPYTHON}" -m twisted.trial txrequests || die "Tests failed with ${EPYTHON}"
}
