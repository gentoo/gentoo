# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1

MY_PN="SecretStorage"

DESCRIPTION="Python bindings to FreeDesktop.org Secret Service API"
HOMEPAGE="
	https://github.com/mitya57/secretstorage/
	https://pypi.org/project/SecretStorage/
"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/cryptography[${PYTHON_USEDEP}]
	>=dev-python/jeepney-0.6[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		!hppa? ( !sparc? ( !s390? (
			sys-apps/dbus
			virtual/secret-service
		) ) )
	)
"

distutils_enable_tests unittest
distutils_enable_sphinx docs \
	dev-python/alabaster

src_test() {

	if ! has_version "virtual/secret-service"; then
		einfo "gnome-keyring is not supported on ${ARCH}, skipping tests"
		return
	fi

	distutils-r1_src_test
}

python_test() {
	dbus-run-session "${EPYTHON}" -m unittest discover -v -s tests \
		|| die "tests failed with ${EPYTHON}"
}
