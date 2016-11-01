# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5} pypy )

inherit distutils-r1

MY_P="${P/_p/.post}"

DESCRIPTION="Allows using distutils2-like setup.cfg files for a package metadata"
HOMEPAGE="https://pypi.python.org/pypi/d2to1 https://github.com/embray/d2to1"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/nose[${PYTHON_USEDEP}]"

S="${WORKDIR}"/${MY_P}

python_prepare_all() {
	rm ${PN}/extern/six.py || die
	cat > ${PN}/extern/__init__.py <<- EOF
	import six
	EOF
	sed \
		-e 's:.extern.six:six:g' \
		-i ${PN}/*py || die
	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
}
