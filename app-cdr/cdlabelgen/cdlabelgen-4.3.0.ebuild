# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="CD cover, tray card and envelope generator"
HOMEPAGE="http://www.aczoom.com/tools/cdinsert"
SRC_URI="http://www.aczoom.com/pub/tools/${P}.tgz"
LICENSE="aczoom"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="dev-lang/perl"
DEPEND=""

PATCHES=( "${FILESDIR}"/4.0.0-create-MAN_DIR.diff )
DOCS=( ChangeLog README INSTALL.WEB )

src_install() {
	emake BASE_DIR="${D}"/usr install
	einstalldocs
	insinto "/usr/share/${PN}"
	doins *.html
	exeinto "/usr/share/${PN}"
	doexe cdinsert{,-ps}.pl
}
