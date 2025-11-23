# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit perl-functions

DESCRIPTION="onis not irc stats"
HOMEPAGE="http://verplant.org/onis/"
SRC_URI="http://verplant.org/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

RDEPEND="dev-lang/perl"
BDEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/0.6.0-nochdir.patch )

src_prepare() {
	default
	sed -i -e s:lang/:/usr/share/onis/lang/: onis.conf || die "sed failed"
}

src_install() {
	dobin onis

	perl_domodule -r lib/Onis

	insinto /usr/share/onis
	doins -r lang reports/.

	einstalldocs
	dodoc onis.conf users.conf
}

pkg_postinst() {
	elog
	elog "The onis themes have been installed in /usr/share/onis/*-theme"
	elog "You can find a compressed sample configuration at /usr/share/doc/${PF}/config"
	elog
}
