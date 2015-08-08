# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit user

DESCRIPTION="Mails anomalies in the system logfiles to the administrator"
HOMEPAGE="http://packages.debian.org/sid/logcheck"
SRC_URI="mirror://debian/pool/main/l/${PN}/${PN}_${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND=""
RDEPEND="!app-admin/logsentry
	app-misc/lockfile-progs
	dev-lang/perl
	dev-perl/mime-construct
	virtual/mailx
	${DEPEND}"

pkg_setup() {
	enewgroup logcheck
	enewuser logcheck -1 -1 -1 logcheck
}

src_install() {
	emake DESTDIR="${D}" install

	# Do not install /var/lock, bug #449968 . Use rmdir to make sure
	# the directories removed are empty.
	rmdir "${D}/var/lock/logcheck" || die
	rmdir "${D}/var/lock" || die

	keepdir /var/lib/logcheck
	dodoc AUTHORS CHANGES CREDITS TODO docs/README.*
	doman docs/logtail.8 docs/logtail2.8

	exeinto /etc/cron.hourly
	doexe "${FILESDIR}/${PN}.cron"
}

pkg_postinst() {
	chown -R logcheck:logcheck /etc/logcheck /var/lib/logcheck || die

	elog "Please read the guide ad http://www.gentoo.org/doc/en/logcheck.xml"
	elog "for installation instructions."
}
