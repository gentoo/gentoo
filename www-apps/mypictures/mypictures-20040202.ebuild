# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/mypictures/mypictures-20040202.ebuild,v 1.3 2012/09/18 04:23:44 radhermit Exp $

inherit webapp eutils

DESCRIPTION="Simple photo-gallery for websites"
HOMEPAGE="http://www.splitbrain.org/Programming/PHP/mypictures/index.php"
SRC_URI="http://www.splitbrain.org/Programming/PHP/mypictures/mypictures.tgz"

LICENSE="GPL-2"
KEYWORDS="~x86 ppc"
IUSE=""

DEPEND="sys-apps/sed"
RDEPEND="media-gfx/imagemagick"

S=${WORKDIR}/${PN}

src_unpack () {
	unpack ${A}
	cd "${S}"

	# we have to patch the path to imagemagick's convert tool

	epatch "${FILESDIR}"/mypictures.diff
	sed -i "s|/usr/bin/X11/convert|/usr/bin/convert|g;" index.php
}

src_compile() {
	# do nothing
	echo > /dev/null
}

src_install() {
	webapp_src_preinst

	cp index.php exifReader.inc exifWriter.inc "${D}${MY_HTDOCSDIR}"
	mkdir "${D}${MY_HTDOCSDIR}"/.img
	cp .img/* "${D}${MY_HTDOCSDIR}"/.img

	dodoc CHANGES README

	webapp_configfile "${MY_HTDOCSDIR}"
	webapp_src_install
}
