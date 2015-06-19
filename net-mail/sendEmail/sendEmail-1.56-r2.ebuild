# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/sendEmail/sendEmail-1.56-r2.ebuild,v 1.3 2014/01/14 13:56:39 ago Exp $

EAPI=5
MY_P="${PN}-v${PV}"

inherit base

DESCRIPTION="Command line based, SMTP email agent"
HOMEPAGE="http://caspian.dotconf.net/menu/Software/SendEmail/"
SRC_URI="http://caspian.dotconf.net/menu/Software/SendEmail/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="ssl"

DEPEND=""
RDEPEND="dev-lang/perl
	ssl? ( dev-perl/IO-Socket-SSL )"

PATCHES=( "${FILESDIR}/${PV}-overzealous-version-check.patch"
	  "${FILESDIR}/${PV}-overzealous-verify-mode-check.patch" )
S="${WORKDIR}/${MY_P}"

src_install() {
	dobin sendEmail || die "failed to install sendEmail script"
	dodoc CHANGELOG  README  TODO
}
