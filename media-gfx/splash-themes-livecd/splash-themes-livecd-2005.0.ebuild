# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

MY_P="gentoo-livecd-${PV}"
MY_REV="0.9.1"
DESCRIPTION="Gentoo theme for gensplash consoles"
HOMEPAGE="https://www.gentoo.org/"
SRC_URI="https://dev.gentoo.org/~wolf31o2/sources/${PN}/${MY_P}-${MY_REV}.tar.bz2"

SLOT=${PV}
LICENSE="Artistic GPL-2 BitstreamVera"
KEYWORDS="amd64 ~ppc x86"
IUSE=""
RESTRICT="binchecks strip"

DEPEND=">=media-gfx/splashutils-0.9.1"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e 's-/sbin/functions.sh-/etc/init.d/functions.sh-' scripts/rc_init-pre scripts/list_svc.sh
}

src_install() {
	dodir /etc/splash/livecd-${PV}
	cp -r "${S}"/* "${D}"/etc/splash/livecd-${PV}
}
