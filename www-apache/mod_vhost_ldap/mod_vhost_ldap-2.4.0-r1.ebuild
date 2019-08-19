# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit apache-module

DESCRIPTION="Store and configure Apache virtual hosts using LDAP"
HOMEPAGE="https://github.com/oerdnj/mod-vhost-ldap"
SRC_URI="https://dev.gentoo.org/~mjo/distfiles/${P}.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

APACHE2_MOD_CONF="99_${PN}"
APACHE2_MOD_DEFINE="VHOST_LDAP LDAP"

DOCFILES="AUTHORS ChangeLog README"

# We need apr-util[ldap] and apache to build, but the ldap module for
# apache is only needed when we try to run the thing.
DEPEND="dev-libs/apr-util[ldap]"
RDEPEND="=www-servers/apache-2.4*[ldap]"

need_apache2_4

src_prepare() {
	default

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
