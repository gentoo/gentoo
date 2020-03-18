# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils flag-o-matic toolchain-funcs

DEB_PV="1.5-6"
DESCRIPTION="Standard log daemons"
HOMEPAGE="http://www.infodrom.org/projects/sysklogd/"
SRC_URI="http://www.infodrom.org/projects/sysklogd/download/${P}.tar.gz
	mirror://debian/pool/main/s/sysklogd/${PN}_${DEB_PV}.diff.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE="logrotate"
RESTRICT="test"

DEPEND=""
RDEPEND="dev-lang/perl
	sys-apps/debianutils"

DOCS=( ANNOUNCE CHANGES NEWS README.1st README.linux )

PATCHES=(
	"${WORKDIR}"/${PN}_${DEB_PV}.diff

	"${FILESDIR}"/${PN}-1.5-debian-cron.patch
	"${FILESDIR}"/${PN}-1.5-build.patch

	# CAEN/OWL security patches
	"${FILESDIR}"/${PN}-1.4.2-caen-owl-syslogd-bind.diff
	"${FILESDIR}"/${PN}-1.4.2-caen-owl-syslogd-drop-root.diff
	"${FILESDIR}"/${PN}-1.4.2-caen-owl-klogd-drop-root.diff

	"${FILESDIR}"/${PN}-1.5-syslog-func-collision.patch #342601
	"${FILESDIR}"/${PN}-1.5-glibc-2.24.patch #604232
)

src_prepare() {
	epatch "${PATCHES[@]}"
}

src_configure() {
	append-lfs-flags
	tc-export CC
}

src_install() {
	dosbin syslogd klogd debian/syslog-facility debian/syslogd-listfiles
	doman *.[1-9] debian/syslogd-listfiles.8
	insinto /etc
	doins debian/syslog.conf
	if use logrotate ; then
		insinto /etc/logrotate.d
		newins "${FILESDIR}"/sysklogd.logrotate sysklogd
	else
		exeinto /etc/cron.daily
		newexe debian/cron.daily syslog
		exeinto /etc/cron.weekly
		newexe debian/cron.weekly syslog
	fi

	einstalldocs

	newinitd "${FILESDIR}"/sysklogd.rc7 sysklogd
	newconfd "${FILESDIR}"/sysklogd.confd sysklogd
}
