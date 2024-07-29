# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="CD cover, tray card and envelope generator"
HOMEPAGE="https://www.aczoom.com/tools/cdinsert"
SRC_URI="https://www.aczoom.com/pub/tools/${P}.tgz"

LICENSE="aczoom"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"

RDEPEND="dev-lang/perl"

PATCHES=( "${FILESDIR}"/4.0.0-create-MAN_DIR.diff )

src_install() {
	emake BASE_DIR="${ED}"/usr install
	dodoc ChangeLog README INSTALL.WEB

	insinto /usr/share/cdlabelgen
	doins *.html

	exeinto /usr/share/cdlabelgen
	doexe cdinsert{,-ps}.pl
}
