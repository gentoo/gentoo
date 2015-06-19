# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xclip/xclip-0.12.ebuild,v 1.10 2013/03/04 10:40:53 vapier Exp $

DESCRIPTION="Command-line utility to read data from standard in and place it in an X selection"
HOMEPAGE="http://sourceforge.net/projects/xclip/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXmu"
DEPEND="${RDEPEND}
	x11-libs/libXt"

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc ChangeLog README
}
