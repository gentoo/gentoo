# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1

DESCRIPTION="WTForms integration for peewee models"
HOMEPAGE="https://github.com/coleifer/wtf-peewee/"
SRC_URI="https://github.com/coleifer/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples test"

RDEPEND=">=dev-python/peewee-2.7.4[${PYTHON_USEDEP}]
	dev-python/wtforms[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	"${PYTHON}" ./runtests.py || die "Testing failed with ${EPYTHON}"
}

python_install_all() {
	use examples && dodoc -r example
	distutils-r1_python_install_all
}
