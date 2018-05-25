# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit readme.gentoo-r1 user

DESCRIPTION="Mails anomalies in the system logfiles to the administrator"
HOMEPAGE="https://packages.debian.org/sid/logcheck"
SRC_URI="mirror://debian/pool/main/l/${PN}/${PN}_${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	!app-admin/logsentry
	app-misc/lockfile-progs
	dev-lang/perl
	dev-perl/mime-construct
	virtual/mailx
"

DOC_CONTENTS="
	Please read the guide at https://wiki.gentoo.org/wiki/Logcheck
	for installation instructions.
"

pkg_setup() {
	enewgroup logcheck
	enewuser logcheck -1 -1 -1 logcheck
}

src_prepare() {
	default
	# Add /var/log/messages support, bug #531524
	echo "/var/log/messages" >> etc/logcheck.logfiles
}

src_install() {
	default

	# Do not install /var/lock, bug #449968 . Use rmdir to make sure
	# the directories removed are empty.
	rmdir "${D}/var/lock/logcheck" || die
	rmdir "${D}/var/lock" || die

	keepdir /var/lib/logcheck

	readme.gentoo_create_doc
	dodoc AUTHORS CHANGES CREDITS TODO docs/README.*
	doman docs/logtail.8 docs/logtail2.8

	exeinto /etc/cron.hourly
	doexe "${FILESDIR}/${PN}.cron"
}

pkg_postinst() {
	chown -R logcheck:logcheck /etc/logcheck /var/lib/logcheck || die
	readme.gentoo_print_elog
}
