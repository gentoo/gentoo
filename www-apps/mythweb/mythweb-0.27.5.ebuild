# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils webapp

#BACKPORTS="4f6ac2a60b"
# Release version
MY_PV="${PV%_p*}"
MY_P="mythweb-${MY_PV}"

DESCRIPTION="PHP scripts intended to manage MythTV from a web browser"
HOMEPAGE="http://www.mythtv.org"
LICENSE="GPL-2"
SRC_URI="https://github.com/MythTV/mythweb/archive/v${MY_PV}.tar.gz -> mythweb-${MY_PV}.tar.gz
	${BACKPORTS:+https://dev.gentoo.org/~cardoe/distfiles/${MY_P}-${BACKPORTS}.tar.xz}"
IUSE=""
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="dev-lang/php[json,mysql,session,posix]
	virtual/httpd-php
	dev-perl/DBI
	dev-perl/DBD-mysql
	dev-perl/HTTP-Date
	dev-perl/Net-UPnP"

DEPEND="${RDEPEND}"

need_httpd_cgi

S="${WORKDIR}/${MY_P}"

src_prepare() {
	cd "${S}"/../

	[[ -n ${BACKPORTS} ]] && \
		EPATCH_FORCE=yes EPATCH_SUFFIX="patch" EPATCH_SOURCE="${S}/../patches" \
			epatch

	epatch_user
}

src_configure() {
	:
}

src_compile() {
	:
}

src_install() {
	webapp_src_preinst

	# Install docs
	cd "${S}"
	dodoc README INSTALL

	# Install htdocs files
	insinto "${MY_HTDOCSDIR}"
	doins mythweb.php
	doins -r classes
	doins -r configuration
	doins -r data
	doins -r includes
	doins -r js
	doins -r modules
	doins -r skins
	doins -r tests
	exeinto "${MY_HTDOCSDIR}"
	doexe mythweb.pl

	# Install our server config files
	webapp_server_configfile apache mythweb.conf.apache mythweb.conf
	webapp_server_configfile lighttpd mythweb.conf.lighttpd mythweb.conf
	webapp_server_configfile nginx "${FILESDIR}"/mythweb.conf.nginx \
		mythweb.include

	# Data needs to be writable and modifiable by the web server
	webapp_serverowned -R "${MY_HTDOCSDIR}"/data

	# Message to display after install
	webapp_postinst_txt en "${FILESDIR}"/0.25-postinstall-en.txt

	# Script to set the correct defaults on install
	webapp_hook_script "${FILESDIR}"/reconfig

	webapp_src_install
}
