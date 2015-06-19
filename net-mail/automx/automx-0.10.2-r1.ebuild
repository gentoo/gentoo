# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/automx/automx-0.10.2-r1.ebuild,v 1.3 2015/03/25 14:01:52 ago Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="A mail user agent auto configuration service"
HOMEPAGE="http://www.automx.org"
SRC_URI="https://github.com/sys4/${PN}/archive/v${PV}.tar.gz -> automx-${PV}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="ldap memcached sql +tools"

DEPEND="
	dev-python/ipaddr[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	|| ( www-apache/mod_wsgi[${PYTHON_USEDEP}] www-servers/uwsgi )
	ldap? ( dev-python/python-ldap[${PYTHON_USEDEP}]  )
	memcached? ( dev-python/python-memcached[${PYTHON_USEDEP}] )
	sql? ( dev-python/sqlalchemy[${PYTHON_USEDEP}] )
	tools? ( net-dns/bind-tools net-misc/wget )
	"
RDEPEND="${DEPEND}"

python_prepare_all() {
	sed -i '/py_modules=/d' setup.py || die
	distutils-r1_python_prepare_all
}

python_install_all() {
	DOCS=( INSTALL CREDITS CHANGES BASIC_CONFIGURATION_README )
	HTML_DOCS=( doc/html/. )

	distutils-r1_python_install_all

	docinto examples
	dodoc src/conf/*example*

	doman doc/man/man5/*

	if use tools; then
		dobin src/automx-test
		doman doc/man/man1/automx-test.1
	fi

	exeinto /usr/lib/${PN}
	doexe src/automx_wsgi.py
}

pkg_postinst() {
	echo
	einfo "See /usr/share/doc/${PF}/INSTALL.bz2 for setup instructions"
	echo
}
