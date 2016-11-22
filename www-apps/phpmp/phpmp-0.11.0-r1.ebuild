# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit webapp

MY_PN="phpMp"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="phpMp is a client program for Music Player Daemon (mpd)"
HOMEPAGE="https://www.musicpd.org/"
SRC_URI="mirror://sourceforge/musicpd/${MY_P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="alpha amd64 ~ppc sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="virtual/httpd-php
	|| ( <dev-lang/php-5.3[pcre] >=dev-lang/php-5.3 )"

need_httpd_cgi

S="${WORKDIR}"/${MY_P}

src_install() {
	webapp_src_preinst

	dodoc ChangeLog README TODO
	rm -f ChangeLog COPYING INSTALL README TODO

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_configfile "${MY_HTDOCSDIR}"/config.php

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_src_install
}
