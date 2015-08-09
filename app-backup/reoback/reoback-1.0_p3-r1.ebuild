# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Reoback Backup Solution"
HOMEPAGE="http://reoback.sourceforge.net/"
SRC_URI="mirror://sourceforge/reoback/reoback-${PV/_p/_r}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND=">=dev-lang/perl-5.6.1"
DEPEND=">=app-arch/tar-1.13"

S=${WORKDIR}/${PN}-${PV/_*}

src_prepare() {
	ecvs_clean
	sed \
		-e '/^config=/s:=.*:=/etc/reoback/settings.conf:' \
		-e '/^reoback=/s:=.*:=/usr/sbin/reoback.pl:' \
		-i run_reoback.sh || die
}

src_install() {
	dosbin reoback.pl
	insinto /etc/reoback
	doins conf/*
	fperms o-x /usr/sbin/reoback.pl
	insinto /etc/cron.daily
	newins run_reoback.sh reoback
	dodoc docs/{BUGS,CHANGES,INSTALL,MANUALS,README,TODO}
}

pkg_postinst() {
	elog "Reoback can now be activated by simply configuring the files in"
	elog "/etc/reoback and then doing: chmod +x /etc/cron.daily/reoback"
}
