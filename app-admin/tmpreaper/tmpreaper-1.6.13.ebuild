# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
inherit eutils

MY_P="${PN}_${PV}+nmu1"
DESCRIPTION="A utility for removing files based on when they were last accessed"
HOMEPAGE="http://packages.debian.org/sid/tmpreaper"
SRC_URI="mirror://debian/pool/main/t/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_P/_/-}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.6.7-fix-protect.patch
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	insinto /etc
	doins debian/tmpreaper.conf || die "failed to install"

	exeinto /etc/cron.daily
	newexe debian/cron.daily tmpreaper || die "failed to install cron script"
	doman debian/tmpreaper.conf.5 || die
	dodoc README ChangeLog debian/README* || die
}

pkg_postinst() {
	elog "This package installs a cron script under /etc/cron.daily"
	elog "You can configure it using /etc/tmpreaper.conf"
	elog "Consult tmpreaper.conf man page for more information"
	elog "Read /usr/share/doc/${P}/README.security and"
	elog "remove SHOWWARNING from /etc/tmpreaper.conf afterwards"
}
