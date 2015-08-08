# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit webapp

DESCRIPTION="multilanguage CalDAV web client"
HOMEPAGE="http://agendav.org/"
SRC_URI="https://github.com/adobo/${PN}/tarball/${PV} -> ${P}.tar.gz"

LICENSE="BSD LGPL-3+ LGPL-2.1+ GPL-3+"
KEYWORDS="~amd64"

RDEPEND=">=dev-lang/php-5.3[curl,unicode]
	virtual/httpd-php
	|| ( >=virtual/mysql-5.1 >=dev-db/postgresql-8.1 )"

S=${WORKDIR}/adobo-${PN}-84f869e

src_install() {
	webapp_src_preinst

	dodoc \
		doc/source/admin/configuration.rst \
		doc/source/admin/installation.rst \
		doc/source/admin/troubleshooting.rst \
		doc/source/admin/upgrading.rst \
		|| die

	# fix locations
	sed -i \
		-e "s:\(system_path = \)'[^']\+':\1'${MY_HOSTROOTDIR}/${PN}/system':" \
		-e "s:\(application_folder = \)'[^']\+':\1'${MY_HOSTROOTDIR}/${PN}/application':" \
		web/public/index.php || die
	sed -i \
		-e "/require_once/s:'../:'${MY_HOSTROOTDIR}/${PN}/:" \
		web/config/autoload.php || die
	sed -i \
		-e "1a\set_include_path(get_include_path() . PATH_SEPARATOR . APPPATH.'config');" \
		web/config/constants.php || die

	einfo "Installing web files"
	insinto "${MY_HTDOCSDIR}"
	doins -r web/public/* || die

	einfo "Creating configuration container"
	dodir "/etc/agendav"
	local f
	for f in caldav database config ; do
		cp web/config/${f}.php.template "${ED}"/etc/agendav/${f}.php || die
		ln -s "${EPREFIX}"/etc/agendav/${f}.php web/config/${f}.php || die
	done

	einfo "Installing main files"
	insinto "${MY_HOSTROOTDIR}/${PN}"
	doins -r web/{application,config,css_src,lang,system,templates_src,public} \
		|| die
	insinto "${MY_HOSTROOTDIR}/${PN}/application/libraries"
	doins libs/icalcreator/*.php \
		libs/caldav-client/*.php \
		libs/awl/*.php \
		|| die
	dodir /usr/bin
	cat > "${ED}"/usr/bin/agendavcli <<-EOF
		#!/usr/bin/env bash

		exec php "${MY_HOSTROOTDIR}/${PN}/public/index.php" cli "\${@}"
	EOF
	chmod 755 "${ED}"/usr/bin/agendavcli

	einfo "Installing sql files"
	insinto "${MY_SQLSCRIPTSDIR}"
	doins -r sql/* || die

	webapp_postinst_txt en "${FILESDIR}/postinstall-en.txt"
	webapp_src_install
}
