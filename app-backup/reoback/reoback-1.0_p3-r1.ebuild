# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vcs-clean

DESCRIPTION="Reoback Backup Solution"
HOMEPAGE="http://reoback.sourceforge.net/"
SRC_URI="mirror://sourceforge/reoback/reoback-${PV/_p/_r}.tar.gz"
S="${WORKDIR}"/${PN}-${PV/_*}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND=">=dev-lang/perl-5.6.1"
DEPEND=">=app-arch/tar-1.13"

src_prepare() {
	default

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
	elog "${EROOT}/etc/reoback and then doing: chmod +x ${EROOT}/etc/cron.daily/reoback"
}
