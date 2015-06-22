# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/backports-shutil_get_terminal_size/backports-shutil_get_terminal_size-1.0.0-r1.ebuild,v 1.1 2015/06/22 07:25:50 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="backports.shutil_get_terminal_size"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A backport of the get_terminal_size function from Python 3.3's shutil"
HOMEPAGE="https://pypi.python.org/pypi/backports.shutil_get_terminal_size/ https://github.com/chrippa/backports.shutil_get_terminal_size"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/backports[${PYTHON_USEDEP}]"

S=${WORKDIR}/${MY_P}

python_install() {
	distutils-r1_python_install

	# main namespace provided by dev-python/backports
	rm "${ED}$(python_get_sitedir)"/backports/__init__.py* || die
}
