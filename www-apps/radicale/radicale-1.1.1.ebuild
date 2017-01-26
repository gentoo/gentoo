# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit eutils distutils-r1 user

MY_PN="Radicale"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A simple CalDAV calendar server"
HOMEPAGE="http://www.radicale.org/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${MY_P}

RDIR=/var/lib/radicale
LDIR=/var/log/radicale

PATCHES=( "${FILESDIR}"/${P}-config.patch )

pkg_setup() {
	enewgroup radicale
	enewuser radicale -1 -1 ${RDIR} radicale
}

python_install_all() {
	rm README* || die

	# init file
	newinitd "${FILESDIR}"/radicale.init.d radicale

	# directories
	diropts -m0750
	dodir ${RDIR}
	fowners radicale:radicale ${RDIR}
	diropts -m0755
	dodir ${LDIR}
	fowners radicale:radicale ${LDIR}

	# config file
	insinto /etc/${PN}
	doins config logging

	# fcgi and wsgi files
	exeinto /usr/share/${PN}
	doexe radicale.wsgi
	doexe radicale.fcgi

	distutils-r1_python_install_all
}

pkg_postinst() {
	einfo "A sample WSGI script has been put into ${ROOT}usr/share/${PN}."
	einfo "You will also find there an example FastCGI script."

	einfo "Radicale supports different authentication backends that depend on external libraries."
	einfo "Please install"
	optfeature "LDAP auth" dev-python/python-ldap
	optfeature "PAM auth" dev-python/python-pam
	optfeature "HTTP auth" dev-python/requests
	optfeature "FastCGI mode" dev-python/flup
	optfeature "Database storage backend" dev-python/sqlalchemy
	einfo "Please note that some of these libraries are Python 2 only."
}
