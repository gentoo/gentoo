# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

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

PATCHES=( "${FILESDIR}/0.6.0-nochdir.patch" )

src_prepare() {
	default
	sed -i -e s:lang/:/usr/share/onis/lang/: onis.conf || die "sed failed"
}

src_install () {
	eval $(perl -V:installprivlib)

	dobin onis

	insinto "${installprivlib}"
	doins -r lib/Onis

	insinto /usr/share/onis
	doins -r lang reports/*

	dodoc CHANGELOG README THANKS onis.conf users.conf
}

pkg_postinst() {
	elog
	elog "The onis themes have been installed in /usr/share/onis/*-theme"
	elog "You can find a compressed sample configuration at /usr/share/doc/${PF}/config"
	elog
}
