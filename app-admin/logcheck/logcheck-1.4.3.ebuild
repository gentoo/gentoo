# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit readme.gentoo-r1 systemd tmpfiles

DESCRIPTION="Mails anomalies in the system logfiles to the administrator"
HOMEPAGE="https://logcheck.org/"
SRC_URI="https://salsa.debian.org/debian/logcheck/-/archive/debian/${PV}/logcheck-debian-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-debian-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="cron systemd"
# Test (emake system-test) requires access to system logs
RESTRICT="test"

DEPEND="
	acct-group/logcheck
	acct-user/logcheck[systemd?]
"

RDEPEND="
	${DEPEND}
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

src_prepare() {
	default
	# Set version from PV, without using dpkg
	sed -i -e "s/^VERSION=unknown/VERSION=\"${PV}\"/" "${S}/src/logcheck" || die

	# QA-fix remove call to non existent command | Bug: #911281
	sed -i "/dpkg-parsechangelog/d" "${S}/Makefile" || die

	# Add /var/log/messages to checked logs
	echo "/var/log/messages" >> "${S}/etc/logcheck.logfiles.d/syslog.logfiles" || die

	# QA-fix Remove install of empty dirs to be created at runtime
	sed -i "/install -d \$(DESTDIR)\/var\/lock\/logcheck/d" "${S}/Makefile" || die
}

src_install() {
	default

	keepdir /var/lib/logcheck

	dodoc docs/README.*
	doman docs/logtail.8 docs/logtail2.8

	if use cron; then
		exeinto /etc/cron.hourly
		newexe "${FILESDIR}"/${PN}.cron ${PN}
		DOC_CONTENTS="${DOC_CONTENTS}\n
			\n
			Read /etc/cron.hourly/logcheck.cron to activate hourly cron-based check!"
	fi

	if use systemd; then
		DOC_CONTENTS="${DOC_CONTENTS}\n
		\n
		To enable the systemd timer, run the following command:\n
		   systemctl enable --now logcheck.timer"
	fi

	systemd_dounit "${FILESDIR}/${PN}."{service,timer}
	newtmpfiles "${FILESDIR}/logcheck.tmpfiles" logcheck.conf

	readme.gentoo_create_doc

	fowners -R logcheck:logcheck /etc/logcheck /var/lib/logcheck
}

pkg_postinst() {
	tmpfiles_process logcheck.conf

	readme.gentoo_print_elog
}
