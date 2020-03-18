# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="A tool to migrate changesets between version control systems"
HOMEPAGE="http://wiki.darcs.net/index.html/Tailor"
SRC_URI="http://darcs.arstecnica.it/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

DEPEND=""
RDEPEND=""

pkg_setup() {
	python-single-r1_pkg_setup
}

python_install_all() {
	local HTML_DOCS=( README.html )
	distutils-r1_python_install_all
	rm "${D}usr/share/doc/${PF}/README.html"
}

pkg_postinst() {
	elog "Tailor does not explicitly depend on any other VCS."
	elog "You should emerge whatever VCS(s) that you want to use seperately."
}
