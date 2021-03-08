# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} pypy3 )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1

DESCRIPTION="XML bomb protection for Python stdlib modules, an xml serialiser"
HOMEPAGE="https://pypi.org/project/defusedxml/"
SRC_URI="
	https://github.com/tiran/defusedxml/archive/v${PV/_/.}.tar.gz
		-> ${P/_/.}.tar.gz"
S=${WORKDIR}/${P/_/.}

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"

distutils_enable_tests setup.py

src_prepare() {
	default

	mv other examples || die
}

python_install_all() {
	use examples && dodoc -r examples/
	distutils-r1_python_install_all
}
