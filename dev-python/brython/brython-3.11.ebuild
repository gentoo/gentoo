# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit webapp python-single-r1

DESCRIPTION="Python 3 implementation for client-side web programming"
HOMEPAGE="http://www.brython.info"
SRC_URI="
	https://github.com/${PN}-dev/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}"

need_httpd_cgi

pkg_setup() {
	webapp_pkg_setup
	python-single-r1_pkg_setup
}

src_install() {
	dodoc LICENCE.txt README.md
	rm -v LICENCE.txt README.md bower.json .{git*,tra*} server.py || die

	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_src_install
}
