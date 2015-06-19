# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/mypictures/mypictures-20040202-r1.ebuild,v 1.2 2012/09/18 04:23:44 radhermit Exp $

inherit webapp eutils

DESCRIPTION="Simple photo-gallery for websites"
HOMEPAGE="http://www.splitbrain.org/Programming/PHP/mypictures/index.php"
SRC_URI="http://www.splitbrain.org/Programming/PHP/${PN}/${PN}.tgz"

LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"
IUSE=""

RDEPEND="media-gfx/imagemagick"

S=${WORKDIR}/${PN}

src_unpack () {
	unpack ${A}
	cd "${S}"

	# we have to patch the path to imagemagick's convert tool

	epatch "${FILESDIR}"/mypictures.diff
	sed -i "s|/usr/bin/X11/convert|/usr/bin/convert|g;" index.php
}

src_install() {
	webapp_src_preinst

	cp -R [[:lower:]]* .img "${D}/${MY_HTDOCSDIR}"

	dodoc CHANGES README

	webapp_configfile "${MY_HTDOCSDIR}"/index.php
	webapp_serverowned "${MY_HTDOCSDIR}"/.img
	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_src_install
}
