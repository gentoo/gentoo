# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python{3_6,3_7} )

inherit distutils-r1

DESCRIPTION="Initial tagging script for Notmuch"
HOMEPAGE="https://github.com/afewmail/afew"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/chardet[${PYTHON_MULTI_USEDEP}]
		dev-python/dkimpy[${PYTHON_MULTI_USEDEP}]
		net-mail/notmuch[python,${PYTHON_MULTI_USEDEP}]
	')"

DOCS=( "README.rst" )

src_prepare() {
	sed -r \
		-e "s/^([[:space:]]+)use_scm_version=.*,$/\1version='${PV}',/" \
		-e "/^([[:space:]]+)setup_requires=.*,$/d" \
		-i setup.py || die
	distutils-r1_src_prepare
}

src_install() {
	distutils-r1_src_install
	dodoc afew/defaults/afew.config
}
