# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_wsgi/mod_wsgi-3.5.ebuild,v 1.7 2015/04/08 18:28:33 mgorny Exp $

EAPI="5"

PYTHON_COMPAT=( python2_7 python3_3 python3_4 )
PYTHON_REQ_USE="threads"

inherit apache-module eutils python-single-r1

DESCRIPTION="An Apache2 module for running Python WSGI applications"
HOMEPAGE="http://code.google.com/p/modwsgi/"
SRC_URI="https://github.com/GrahamDumpleton/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=""
RDEPEND=""

APACHE2_MOD_CONF="70_${PN}"
APACHE2_MOD_DEFINE="WSGI"

DOCFILES="README"

need_apache2

src_configure() {
	econf --with-apxs=${APXS} --with-python=${PYTHON}
}

src_compile() {
	default
}
