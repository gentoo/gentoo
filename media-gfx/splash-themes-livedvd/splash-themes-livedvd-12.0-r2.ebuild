# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Gentoo theme for gensplash consoles"
HOMEPAGE="https://www.gentoo.org/"
SRC_URI="https://dev.gentoo.org/~tampakrap/tarballs/${P}.tar.bz2"

LICENSE="Artistic GPL-2 BitstreamVera"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="binchecks strip"

DEPEND=">=media-gfx/splashutils-1.4.1[png]"
RDEPEND="${DEPEND}
	sys-apps/gentoo-functions"

src_prepare() {
	epatch "${FILESDIR}"/use-new-path-for-functions.sh.patch
}

src_install() {
	dodir /etc/splash/livedvd-${PV}
	insinto /etc/splash/livedvd-${PV}
	doins -r *
	insopts -m 0755
	doins -r scripts
}
