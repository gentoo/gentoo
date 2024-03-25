# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
PYTHON_REQ_USE="sqlite"
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 optfeature

DESCRIPTION="A lightweight password-manager with multiple database backends"
HOMEPAGE="https://pwman3.github.io/pwman3/"
SRC_URI="https://github.com/pwman3/pwman3/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/cryptography-2.3[${PYTHON_USEDEP}]
	>=dev-python/colorama-0.4.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pexpect[${PYTHON_USEDEP}]
	)
"

python_test() {
	"${EPYTHON}" -m tests.test_pwman || die "Tests fail with ${EPYTHON}"
}

pkg_postinst() {
	optfeature "Support for mongodb" dev-python/pymongo
	optfeature "Support for postgresql" dev-python/psycopg:2
	optfeature "Support for mysql" dev-python/pymysql
}
