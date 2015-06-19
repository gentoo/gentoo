# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/bbpager/bbpager-0.4.7.ebuild,v 1.7 2014/08/10 20:01:18 slyfox Exp $

inherit base autotools

DESCRIPTION="An understated pager for Blackbox"
HOMEPAGE="http://bbtools.sourceforge.net/"
SRC_URI="mirror://sourceforge/bbtools/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd"
IUSE=""

RDEPEND="x11-wm/blackbox"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
		"${FILESDIR}/${P}-gcc43.patch"
		"${FILESDIR}/${P}-as-needed.patch"
	)

src_unpack() {
	base_src_unpack
	cd "${S}"
	eautoreconf
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS BUGS ChangeLog README TODO
}
