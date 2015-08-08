# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit webapp depend.php

# upstream uses dashes in the datestamp
MY_BASE_PV="${PV:0:4}-${PV:4:2}-${PV:6:2}"
MY_PV="${MY_BASE_PV}${PV:8:1}"

DESCRIPTION="DokuWiki is a simple to use Wiki aimed at a small company's documentation needs."
HOMEPAGE="http://wiki.splitbrain.org/wiki:dokuwiki"
SRC_URI="http://download.dokuwiki.org/src/${PN}/${PN}-${MY_PV}.tgz"

LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE="gd"

DEPEND=""
RDEPEND="
	>=dev-lang/php-5.3[xml]
	gd? ( ||
		(
			dev-lang/php[gd]
			media-gfx/imagemagick
		)
	)
"

need_httpd_cgi
need_php_httpd

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	# create initial changes file
	touch data/changes.log
}

src_install() {
	webapp_src_preinst

	dodoc README
	rm -f README COPYING

	docinto scripts
	dodoc bin/*
	rm -rf bin

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	for x in $(find data/ -not -name '.htaccess'); do
		webapp_serverowned "${MY_HTDOCSDIR}"/${x}
	done

	webapp_configfile "${MY_HTDOCSDIR}"/.htaccess.dist
	webapp_configfile "${MY_HTDOCSDIR}"/conf

	for x in $(find conf/ -not -name 'msg'); do
		webapp_configfile "${MY_HTDOCSDIR}"/${x}
	done

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_src_install
}
