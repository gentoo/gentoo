# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Sets up class-based queue traffic control (QoS) with iproute2"
HOMEPAGE="http://www.sourceforge.net/projects/cbqinit"
SRC_URI="mirror://sourceforge/cbqinit/cbq.init-v${PV} -> ${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ~mips ppc sparc x86"
IUSE=""

RDEPEND="sys-apps/iproute2"
DEPEND=""

S=${WORKDIR}

src_unpack() {
	cp "${DISTDIR}"/${P} "${S}"/cbqinit || die
	grep '^#' cbqinit > README
}

src_prepare() {
	eapply -p0 "${FILESDIR}"/${P}-gentoo.patch
	default
}

src_install() {
	dosbin cbqinit
	newinitd "${FILESDIR}"/rc_cbqinit-r1 cbqinit
	dodoc "${FILESDIR}"/cbq-1280.My_first_shaper.sample README
}
