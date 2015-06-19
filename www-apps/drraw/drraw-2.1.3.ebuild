# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/drraw/drraw-2.1.3.ebuild,v 1.5 2015/06/13 17:19:47 dilfridge Exp $

inherit webapp

DESCRIPTION="drraw is a simple web based presentation front-end for RRDtool"
HOMEPAGE="http://web.taranis.org/drraw"
SRC_URI="http://web.taranis.org/${PN}/dist/${P}.tgz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=dev-lang/perl-5.6
	dev-perl/CGI
	>=net-analyzer/rrdtool-1.2.1"

need_httpd_cgi

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e "s|/usr/local/bin/perl|/usr/bin/perl|" drraw.cgi
	sed -i \
		-e "s|/somewhere/drraw/saved|/tmp|" \
		-e "s|/somewhere/drraw/tmp|/tmp|" \
		drraw.conf
}

src_install() {
	webapp_src_preinst

	dodoc CHANGES INSTALL README.EVENTS WISHLIST
	rm CHANGES INSTALL README.EVENTS WISHLIST

	insinto "${MY_CGIBINDIR}"
	doins drraw.conf

	exeinto "${MY_CGIBINDIR}"
	doexe drraw.cgi

	insinto "${MY_ICONSDIR}"
	doins icons/*.gif

	webapp_configfile "${MY_CGIBINDIR}"/drraw.conf

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_src_install
}
