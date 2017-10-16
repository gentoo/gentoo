# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit depend.apache eutils multilib user

DESCRIPTION="Icinga Web 2 - Frontend for icinga2"
HOMEPAGE="http://www.icinga.org/"
SRC_URI="https://codeload.github.com/Icinga/${PN}/tar.gz/v${PV} -> ${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE="apache2 ldap mysql nginx pdf postgres"
REQUIRED_USE="^^ ( apache2 nginx )"
KEYWORDS="~amd64 ~x86"

DEPEND=">=net-analyzer/icinga2-2.1.1
		dev-php/pecl-imagick
		pdf? ( media-gfx/imagemagick[png] )
		apache2? (
			>=www-servers/apache-2.4.0
			|| (
				dev-lang/php:5.6[apache2?,cli,gd,json,intl,ldap?,mysql?,nls,pdo,postgres?,sockets,ssl,xslt,xml]
				dev-lang/php:7.0[apache2?,cli,gd,json,intl,ldap?,mysql?,nls,pdo,postgres?,sockets,ssl,xslt,xml]
				dev-lang/php:7.1[apache2?,cli,gd,json,intl,ldap?,mysql?,nls,pdo,postgres?,sockets,ssl,xslt,xml]
			)
		)
		nginx? (
			>=www-servers/nginx-1.7.0:*
			|| (
				dev-lang/php:5.6[apache2?,cli,fpm,gd,json,intl,ldap?,mysql?,nls,pdo,postgres?,sockets,ssl,xslt,xml]
				dev-lang/php:7.0[apache2?,cli,fpm,gd,json,intl,ldap?,mysql?,nls,pdo,postgres?,sockets,ssl,xslt,xml]
				dev-lang/php:7.1[apache2?,cli,fpm,gd,json,intl,ldap?,mysql?,nls,pdo,postgres?,sockets,ssl,xslt,xml]
			)
		)"
RDEPEND="${DEPEND}"

want_apache2

pkg_setup() {
	depend.apache_pkg_setup

	enewgroup icingaweb2
	enewgroup icingacmd
	use nginx && usermod -a -G icingacmd,icingaweb2 nginx
	use apache2 && usermod -a -G icingacmd,icingaweb2 apache
}

pkg_config() {
	if [[ -d /etc/icingaweb2 ]] ; then
		einfo "Updating existing installation ..."
	else
		einfo "Running first time setup ..."
		einfo "Creating configuration directory ..."
		/usr/share/${PN}/bin/icingacli setup config directory
		einfo "Creating authentication token for web setup ..."
		/usr/share/${PN}/bin/icingacli setup token create
		if use apache2 ; then
			einfo "The following might be useful for your Apache2 configuration:"
			/usr/share/${PN}/bin/icingacli setup config webserver apache --document-root /usr/share/${PN}/public
		fi
		if use nginx ; then
			einfo "The following might be useful for your NGinx configuration:"
			/usr/share/${PN}/bin/icingacli setup config webserver nginx --document-root /usr/share/${PN}/public
		fi
	fi
	einfo "All done."
}

src_install() {
	insinto "/usr/share/${PN}"
	doins -r "${S}"/*
	fperms -R a+rX "/usr/share/${PN}/public/"
	fperms u+x,g+x "/usr/share/${PN}/bin/icingacli"
}

pkg_postinst() {
	einfo "Run 'emerge --config =${CATEGORY}/${PF}' to finish setup."
}
