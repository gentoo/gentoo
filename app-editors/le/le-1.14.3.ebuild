# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/le/le-1.14.3.ebuild,v 1.5 2010/11/01 21:49:36 ssuominen Exp $

DESCRIPTION="Terminal text editor"
HOMEPAGE="http://www.gnu.org/directory/text/editors/le-editor.html"
SRC_URI="ftp://ftp.yars.free.net/pub/source/le/le-${PV}.tar.lzma"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND=">=sys-libs/ncurses-5.2-r5"
DEPEND="${RDEPEND}
	app-arch/xz-utils"

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc ChangeLog FEATURES HISTORY INSTALL NEWS README TODO
}
