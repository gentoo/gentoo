# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nagvis/nagvis-1.6.6.ebuild,v 1.6 2015/06/17 20:07:28 grknight Exp $

EAPI=5

inherit eutils depend.apache

DESCRIPTION="NagVis is a visualization addon for the well known network managment system Nagios"
HOMEPAGE="http://www.nagvis.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="apache2 automap"

DEPEND="virtual/httpd-php"
RDEPEND="|| ( net-analyzer/nagios net-analyzer/icinga )
	automap? ( >=media-gfx/graphviz-2.14 )
	apache2? ( dev-lang/php[apache2] )
	net-analyzer/mk-livestatus
	dev-lang/php[gd,nls,json,session,pdo,sqlite,sockets,mysql,unicode,xml]
	virtual/httpd-php:*"

want_apache2

pkg_setup() {
	depend.apache_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-base-path.patch
	epatch "${FILESDIR}"/${P}-global-definitions.patch
	grep -Rl "/usr/local" "${S}"/* | xargs sed -i s:/usr/local:/usr:g ||die
	sed -i s:@NAGVIS_WEB@:/nagvis:g "${S}"/etc/apache2-nagvis.conf-sample ||die
	sed -i s:@NAGVIS_PATH@:/usr/share/nagvis/:g "${S}"/etc/apache2-nagvis.conf-sample ||die
	sed -i s:/usr/nagios/var/rw/live:/var/nagios/rw/live:g "${S}"/etc/nagvis.ini.php-sample ||die
}

src_install() {
	dodoc README INSTALL

	insinto /usr/share/nagvis
	doins -r share/{config.php,index.php,frontend,netmap,server,userfiles}
	doins -r docs

	diropts -o apache -g root
	dodir /var/nagvis/tmpl/{cache,compile}
	diropts
	dosym /var/nagvis /usr/share/nagvis/var

	if use apache2 ; then
		insinto "${APACHE_MODULES_CONFDIR}"
		newins etc/apache2-nagvis.conf-sample 98_${PN}.conf
	fi

	insinto /etc/nagvis
	doins -r etc/{conf.d,automaps,geomap,.htaccess,nagvis.ini.php-sample}
	fowners apache:root /etc/nagvis
	fperms 0664 /etc/nagvis/nagvis.ini.php-sample
	dosym /etc/nagvis /usr/share/nagvis/etc

	diropts -o apache -g root -m0775
	insopts -o apache -g root -m0664
	doins -r etc/maps
	diropts
	insopts

	# move image maps dir from usr to var and symlink it back
	dodir /var/nagvis/userfiles/images
	mv "${D}"/usr/share/nagvis/userfiles/images/maps "${D}"/var/nagvis/userfiles/images/ ||die
	fowners apache:root /var/nagvis/userfiles/images/maps
	dosym /var/nagvis/userfiles/images/maps /usr/share/nagvis/userfiles/images/maps
}

pkg_postinst() {
	elog "Before running NagVis for the first time, you will need to set up"
	elog "/etc/nagvis/nagvis.ini.php"
	elog "A sample is in"
	elog "/etc/nagvis/nagvis.ini.php-sample"
	if use apache2 ; then
		elog
		elog "For web interface make sure to add -D NAGVIS to APACHE2_OPTS in"
		elog "/etc/conf.d/apache2 and to restart apache2. A default configuration"
		elog "has been placed at /etc/apache2/modules.d/98_${PN}.conf"
	fi
	elog ""
	elog "Default user/password are: nagiosadmin/nagiosadmin"
	elog "                                 guest/guest"
}
