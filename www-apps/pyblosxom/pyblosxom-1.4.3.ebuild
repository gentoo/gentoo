# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/pyblosxom/pyblosxom-1.4.3.ebuild,v 1.5 2014/08/10 20:14:52 slyfox Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit distutils eutils webapp

DESCRIPTION="PyBlosxom is a lightweight weblog system"
HOMEPAGE="http://pyblosxom.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~x86"

# This installs python library files.
SLOT=0
WEBAPP_MANUAL_SLOT=yes

IUSE=""

DEPEND=""
RDEPEND=""

PYTHON_MODNAME="Pyblosxom"

pkg_setup() {
	python_pkg_setup
	webapp_pkg_setup
}

src_prepare() {
	distutils_src_prepare
	epatch "${FILESDIR}/${PN}-1.4.2-gentoo.patch"
}

src_install() {
	webapp_src_preinst

	distutils_src_install
	dodoc README

	keepdir /usr/share/${P}/plugins
	keepdir "${MY_HTDOCSDIR}"/data
	keepdir "${MY_HTDOCSDIR}"/log

	mkdir -p "${D}${MY_CGIBINDIR}"/pyblosxom
	cp web/{config.py,pyblosxom.cgi} "${D}${MY_CGIBINDIR}"/pyblosxom/

	webapp_configfile  "${MY_CGIBINDIR}"/pyblosxom/config.py

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_postupgrade_txt en "${FILESDIR}"/postupgrade-en.txt
	webapp_hook_script "${FILESDIR}"/config-hook.sh

	webapp_src_install
}

pkg_postinst() {
	distutils_pkg_postinst
	webapp_pkg_postinst
}
