# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_vhost_ldap/mod_vhost_ldap-2.4.0.ebuild,v 1.1 2014/12/18 02:11:23 mjo Exp $

EAPI=5

inherit apache-module depend.apache

DESCRIPTION="Store and configure Apache virtual hosts using LDAP"
HOMEPAGE="http://modvhostldap.alioth.debian.org/"
SRC_URI="http://dev.gentoo.org/~mjo/distfiles/${P}.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

APACHE2_MOD_CONF="99_${PN}"
APACHE2_MOD_DEFINE="VHOST_LDAP LDAP"

DOCFILES="AUTHORS ChangeLog README"

# apache[ldap] is needed to run, but not to compile.
DEPEND=""
RDEPEND="=www-servers/apache-2*[ldap]"

need_apache2

src_prepare() {
	sed -i "s/MOD_VHOST_LDAP_VERSION/\"${PV}\"/g" "${PN}.c" || \
		die "failed to sed version string"
}

src_install() {
	apache-module_src_install
	insinto /etc/openldap/schema
	doins mod_vhost_ldap.schema
}

pkg_postinst() {
	apache-module_pkg_postinst
	einfo
	einfo "Your LDAP server needs to include mod_vhost_ldap.schema and should"
	einfo "also maintain indices on apacheServerName and apacheServerAlias."
	einfo
}
