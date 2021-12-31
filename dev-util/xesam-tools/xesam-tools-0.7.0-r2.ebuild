# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml"
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="Development tools and examples for the Xesam desktop search API"
HOMEPAGE="http://xesam.org/people/kamstrup/xesam-tools"
SRC_URI="http://xesam.org/people/kamstrup/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND=""
RDEPEND="
	$(python_gen_cond_dep '
		dev-python/dbus-python[${PYTHON_MULTI_USEDEP}]
		dev-python/pygobject:2[${PYTHON_MULTI_USEDEP}]
		dev-python/pygtk[${PYTHON_MULTI_USEDEP}]
	')"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_install() {
	distutils-r1_src_install

	insinto "/usr/share/doc/${PF}"
	doins -r samples

	if use examples; then
		insinto "/usr/share/doc/${PF}/demo"
		doins "demo/demo.py"
		insopts -m 0755
		doins demo/[^d]*
	fi
}
