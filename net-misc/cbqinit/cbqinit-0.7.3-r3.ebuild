# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Sets up class-based queue traffic control (QoS) with iproute2"
HOMEPAGE="https://sourceforge.net/projects/cbqinit/"
SRC_URI="mirror://sourceforge/cbqinit/cbq.init-v${PV} -> ${P}"
S="${WORKDIR}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~mips ppc sparc x86"

RDEPEND="sys-apps/iproute2"

src_unpack() {
	cp "${DISTDIR}"/${P} "${S}"/cbqinit || die
	grep '^#' cbqinit > README
}

src_prepare() {
	eapply -p0 "${FILESDIR}"/${P}-gentoo.patch
	sed -i -e 's:/sbin/ip:/bin/ip:' cbqinit || die
	default
}

src_install() {
	dosbin cbqinit
	newinitd "${FILESDIR}"/rc_cbqinit-r1 cbqinit
	dodoc "${FILESDIR}"/cbq-1280.My_first_shaper.sample README
}
