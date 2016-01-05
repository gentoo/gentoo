# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit webapp versionator

MY_PV=$(replace_version_separator '_' '-')

DESCRIPTION="A powerful Open Source Content Management System"
HOMEPAGE="http://www.joomla.org/"
M_PN="Joomla_${MY_PV}-Stable-Full_Package"
SRC_URI="https://github.com/${PN}/${PN}-cms/releases/download/${MY_PV}/${M_PN}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

S="${WORKDIR}"
need_httpd_cgi

RDEPEND=">=dev-lang/php-5.3.10[json,zlib,xml]
	virtual/httpd-php
	|| ( dev-lang/php[mysql] dev-lang/php[postgres] )"

src_install () {
	webapp_src_preinst

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
