# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1 prefix

DESCRIPTION="framework for ebuild generators"
HOMEPAGE="https://gitweb.gentoo.org/proj/g-sorcery.git
	https://github.com/jauhien/g-sorcery"
SRC_URI="https://gitweb.gentoo.org/proj/g-sorcery.git/snapshot/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="bson git test"
RESTRICT="!test? ( test )"

BDEPEND="
	bson? ( dev-python/pymongo[${PYTHON_USEDEP}] )
	git? ( dev-vcs/git )
	sys-apps/portage[${PYTHON_USEDEP}]"
RDEPEND="${BDEPEND}"
PDEPEND=">=app-portage/layman-2.2.0[g-sorcery(-),${PYTHON_USEDEP}]"

src_prepare() {
	hprefixify setup.py
	default
}

python_test() {
	PYTHONPATH="." "${PYTHON}" scripts/run_tests.py || die
}

python_install_all() {
	distutils-r1_python_install_all

	doman docs/*.8

	docinto html
	dodoc docs/developer_instructions.html

	diropts -m0777
	keepdir /var/lib/g-sorcery
}
