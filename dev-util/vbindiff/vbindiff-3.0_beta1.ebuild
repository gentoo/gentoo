# Copyright 2007-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/vbindiff/vbindiff-3.0_beta1.ebuild,v 1.5 2008/06/21 08:02:17 opfer Exp $

DESCRIPTION="Visual binary diff utility"

HOMEPAGE="http://www.cjmweb.net/vbindiff/"
SRC_URI="http://www.cjmweb.net/vbindiff/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd"
IUSE=""

RDEPEND="sys-libs/ncurses"
DEPEND="${RDEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS NEWS README README.PuTTY
}
