# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_7,3_8} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1 prefix

DESCRIPTION="framework for ebuild generators"
HOMEPAGE="https://github.com/jauhien/g-sorcery"
SRC_URI="https://github.com/jauhien/g-sorcery/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="bson git test"
RESTRICT="!test? ( test )"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"

DEPEND="bson? ( dev-python/pymongo[${PYTHON_USEDEP}] )
	git? ( dev-vcs/git )
	sys-apps/portage[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
PDEPEND=">=app-portage/layman-2.2.0[g-sorcery(-),${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}/g-sorcery-0.2.1-py3.7.tests-fix.patch"
)

src_prepare() {
	hprefixify setup.py
	default
}

python_test() {
	PYTHONPATH="." "${PYTHON}" scripts/run_tests.py
}

python_install_all() {
	distutils-r1_python_install_all

	doman docs/*.8
	dohtml docs/developer_instructions.html
	diropts -m0777
	dodir /var/lib/g-sorcery
}
