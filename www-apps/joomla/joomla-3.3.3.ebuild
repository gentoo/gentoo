# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/joomla/joomla-3.3.3.ebuild,v 1.3 2014/09/05 16:54:18 williamh Exp $

EAPI=5

inherit webapp depend.php

MAGIC_1="19665"
MAGIC_2="160049"

DESCRIPTION="Joomla is a powerful Open Source Content Management System"
HOMEPAGE="http://www.joomla.org/"
SRC_URI="http://joomlacode.org/gf/download/frsrelease/${MAGIC_1}/${MAGIC_2}/Joomla_${PV}-Stable-Full_Package.zip"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="mysql postgres"

need_httpd_cgi
need_php_httpd

S="${WORKDIR}"

DEPEND="${DEPEND}
	app-arch/unzip"
RDEPEND=">=dev-lang/php-5.3.10[json,mysql?,postgres?,zlib,xml]"

REQUIRED_USE="|| ( mysql postgres )"

src_install () {
	webapp_src_preinst

	dodoc installation/CHANGELOG installation/INSTALL README.txt

	touch configuration.php
	insinto "${MY_HTDOCSDIR}"
	doins -r .

	local files=" administrator/cache administrator/components
	administrator/language administrator/language/en-GB
	administrator/manifests/packages
	administrator/modules administrator/templates cache components images installation
	images/banners language language/en-GB media modules plugins
	plugins/authentication plugins/content plugins/editors plugins/editors-xtd
	plugins/search plugins/system plugins/user plugins tmp templates"

	for file in ${files}; do
		webapp_serverowned -R "${MY_HTDOCSDIR}"/${file}
	done

	webapp_configfile "${MY_HTDOCSDIR}"/configuration.php
	webapp_serverowned "${MY_HTDOCSDIR}"/configuration.php

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_postinst_txt sv "${FILESDIR}"/postinstall-sv.txt
	webapp_src_install
}
