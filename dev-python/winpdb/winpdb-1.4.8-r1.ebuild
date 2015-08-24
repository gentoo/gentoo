# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Graphical Python debugger"
HOMEPAGE="http://winpdb.org/ https://code.google.com/p/winpdb/ https://pypi.python.org/pypi/winpdb"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~x86"
IUSE="+wxwidgets"

DEPEND=">=dev-python/pycrypto-2.0.1[${PYTHON_USEDEP}]
	wxwidgets? ( dev-python/wxpython:2.8[$(python_gen_usedep 'python2*')] )"
RDEPEND="${DEPEND}"

REQUIRED_USE="wxwidgets? ( $(python_gen_useflags 'python2*') )"

python_install() {
	distutils-r1_python_install

	if ! use wxwidgets || python_is_python3; then
		find "${D%/}$(python_get_sitedir)" -name 'winpdb*.py*' -delete || die
		rm "${D%/}$(python_get_scriptdir)"/winpdb || die
		if ! use wxwidgets; then
			rm "${ED%/}"/usr/bin/winpdb || die
		fi
	fi
}
