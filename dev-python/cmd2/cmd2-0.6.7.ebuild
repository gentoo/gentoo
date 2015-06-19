# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/cmd2/cmd2-0.6.7.ebuild,v 1.7 2015/04/08 08:05:16 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Extra features for standard library's cmd module"
HOMEPAGE="https://bitbucket.org/catherinedevlin/cmd2"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=dev-python/pyparsing-2.0.1[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

#python_prepare_all() {
#	# Remove broken pyparsing dep.
#	# https://bitbucket.org/catherinedevlin/cmd2/pull-request/3
#	sed -i -e '/= install_requires/d' setup.py || die
#
#	distutils-r1_python_prepare_all
#}

python_test() {
	cd "${BUILD_DIR}"/lib || die
	"${PYTHON}" -m cmd2 -v || die "Tests fail with ${EPYTHON}"
}
