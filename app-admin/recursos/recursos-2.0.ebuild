# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/recursos/recursos-2.0.ebuild,v 1.10 2014/08/10 01:37:40 patrick Exp $

EAPI=4

DESCRIPTION="Script to create html and text report about your system"
HOMEPAGE="http://www.josealberto.org"
SRC_URI="mirror://gentoo/${P}.tbz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="|| ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] )
	app-shells/bash
	net-analyzer/rrdtool[graph]"

S=${WORKDIR}/r2

src_install() {
	WWWDIR="/var/www/localhost/htdocs/R2"

	insinto /etc
	doins recursos2.conf

	dobin R2createrrd.sh R2generarrd.sh R2updaterrd.sh Recursos2.sh

	dodir ${WWWDIR}
	insinto ${WWWDIR}
	doins R2/*.html

	dodir ${WWWDIR}/common
	insinto ${WWWDIR}/common
	doins R2/common/*

	dodir ${WWWDIR}/rrd/mini
}

pkg_postinst() {
	elog "Fist you must configure /etc/recursos2.conf"
	elog "Then follow these steps:"
	elog
	elog "1. Run R2createrrd.sh"
	elog
	elog "2. Add crontab jobs (this is an example):"
	elog "*/2 * * * *     root    /usr/bin/R2updaterrd.sh"
	elog "*/5 * * * *     root    /usr/bin/R2generarrd.sh"
	elog "*/10 * * * *    root    /usr/bin/Recursos2.sh \ "
	elog "    title general system disks net \ "
	elog "    > /var/www/localhost/htdocs/recursos.html"
	elog
	elog "You can use Recursos2.sh to extract info about your system"
	elog "in html or plain text and mail the file or whatever."
	elog
}
