# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="onis not irc stats"
HOMEPAGE="http://verplant.org/onis/"
SRC_URI="http://verplant.org/${PN}/${P}.tar.bz2"
LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/0.6.0-nochdir.patch

	sed -i -e s:lang/:/usr/share/onis/lang/: onis.conf || die "sed failed"
}

src_install () {
	eval $(perl -V:installprivlib)

	dobin onis || die "dobin failed"

	insinto "${installprivlib}"
	doins -r lib/Onis || die "doins failed"

	insinto /usr/share/onis
	doins -r lang reports/* || die "doins failed"

	dodoc CHANGELOG README THANKS onis.conf users.conf
}

pkg_postinst() {
	elog
	elog "The onis themes have been installed in /usr/share/onis/*-theme"
	elog "You can find a compressed sample configuration at /usr/share/doc/${PF}/config"
	elog
}
