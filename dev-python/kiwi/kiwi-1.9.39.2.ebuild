# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 versionator virtualx

DESCRIPTION="Kiwi is a pure Python framework and set of enhanced PyGTK widgets"
HOMEPAGE="http://www.async.com.br/projects/kiwi/
	https://launchpad.net/kiwi
	https://pypi.python.org/pypi/kiwi-gtk"
MY_PN="${PN}-gtk"
MY_P="${MY_PN}-${PV}"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-interix ~amd64-linux ~x86-linux"
IUSE="examples test"

RDEPEND=">=dev-python/setuptools-0.8[${PYTHON_USEDEP}]
		>=dev-python/pygtk-2.24[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/mock[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	sed -e "s:share/doc/kiwi:share/doc/${PF}:g" -i setup.py || die "sed failed"
	distutils-r1_python_prepare_all
}

python_test() {
	testing() {
		"${PYTHON}" -m unittest discover || die "tests failed"
	}
	VIRTUALX_COMMAND=virtualmake testing
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
	rmdir "${D}"usr/share/doc/${PF}/{api,howto} || die
}
