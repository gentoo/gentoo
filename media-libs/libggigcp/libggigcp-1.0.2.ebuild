# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libggigcp/libggigcp-1.0.2.ebuild,v 1.3 2009/09/14 21:26:33 maekke Exp $

DESCRIPTION="Library for General Graphics Interface"
HOMEPAGE="http://www.ggi-project.org"
SRC_URI="mirror://sourceforge/ggi/${P}.src.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND=">=media-libs/libggi-2.2.2"
DEPEND="${RDEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc ChangeLog README doc/{TODO,*.txt,*.faq}
}
