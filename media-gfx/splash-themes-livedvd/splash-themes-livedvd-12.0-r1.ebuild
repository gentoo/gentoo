# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/splash-themes-livedvd/splash-themes-livedvd-12.0-r1.ebuild,v 1.1 2013/03/12 11:25:36 alonbl Exp $

EAPI=4

inherit eutils

DESCRIPTION="Gentoo theme for gensplash consoles"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="http://dev.gentoo.org/~tampakrap/tarballs/${P}.tar.bz2"

LICENSE="Artistic GPL-2 BitstreamVera"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="binchecks strip"

DEPEND=">=media-gfx/splashutils-1.4.1[png]"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e 's:/sbin/functions.sh:/etc/init.d/functions.sh:' scripts/rc_init-pre
}

src_install() {
	dodir /etc/splash/livedvd-${PV}
	insinto /etc/splash/livedvd-${PV}
	doins -r *
	insopts -m 0755
	doins -r scripts
}
