# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=(python{2_7,3_4,3_5})

inherit distutils-r1 prefix

DESCRIPTION="framework for ebuild generators"
HOMEPAGE="https://github.com/jauhien/g-sorcery"
SRC_URI="https://github.com/jauhien/g-sorcery/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="bson git"
KEYWORDS="~amd64 ~arm ~hppa ~x86"

DEPEND="bson? ( dev-python/pymongo[${PYTHON_USEDEP}] )
	git? ( dev-vcs/git )
	sys-apps/portage[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
PDEPEND=">=app-portage/layman-2.2.0[g-sorcery(-),${PYTHON_USEDEP}]"

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
