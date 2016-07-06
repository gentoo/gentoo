# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit eutils

DESCRIPTION="CD cover, tray card and envelope generator"
HOMEPAGE="http://www.aczoom.com/tools/cdinsert"
SRC_URI="http://www.aczoom.com/pub/tools/${P}.tgz"

LICENSE="aczoom"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE=""

RDEPEND="dev-lang/perl"
DEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/4.0.0-create-MAN_DIR.diff
}

src_install() {
	emake BASE_DIR="${D}"/usr install || die "emake install failed"
	dodoc cdinsert.pl ChangeLog INSTALL.WEB
	dohtml *.html
}
