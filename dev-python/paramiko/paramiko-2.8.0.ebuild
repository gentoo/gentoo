# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="SSH2 protocol library"
HOMEPAGE="https://www.paramiko.org/ https://github.com/paramiko/paramiko/ https://pypi.org/project/paramiko/"
# pypi tarballs are missing test data
#SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris"
IUSE="examples server"

RDEPEND="
	>=dev-python/bcrypt-3.1.3[${PYTHON_USEDEP}]
	>=dev-python/cryptography-2.5[${PYTHON_USEDEP}]
	>=dev-python/pynacl-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-0.1.7[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx sites/docs
distutils_enable_tests pytest

src_prepare() {
	eapply "${FILESDIR}/${PN}-2.7.1-tests.patch"

	if ! use server; then
		eapply "${FILESDIR}/${PN}-2.4.2-disable-server.patch"
	fi

	eapply_user
}

python_install_all() {
	distutils-r1_python_install_all

	if use examples; then
		docinto examples
		dodoc -r demos/*
	fi
}
