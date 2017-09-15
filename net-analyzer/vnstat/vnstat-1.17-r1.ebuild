# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
inherit systemd toolchain-funcs user versionator

DESCRIPTION="Console-based network traffic monitor that keeps statistics of network usage"
HOMEPAGE="http://humdi.net/vnstat/"
SRC_URI="http://humdi.net/vnstat/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="gd selinux test"

COMMON_DEPEND="
	gd? ( media-libs/gd[png] )
"
DEPEND="
	${COMMON_DEPEND}
	test? ( dev-libs/check )
"
RDEPEND="
	${COMMON_DEPEND}
	selinux? ( sec-policy/selinux-vnstatd )
"

pkg_setup() {
	enewgroup vnstat
	enewuser vnstat -1 -1 /var/lib/vnstat vnstat
}

src_prepare() {
	default

	tc-export CC

	sed -i \
		-e 's|^\(MaxBWethnone.*\)$|#\1|' \
		-e 's|^Daemon\(.*\) ""$|Daemon\1 "vnstat"|' \
		-e 's|vnstat[.]log|vnstatd.log|' \
		-e 's|vnstat[.]pid|vnstatd.pid|' \
		-e 's|/var/run|/run|' \
		cfg/${PN}.conf || die
	sed -i \
		-e '/PIDFILE/s|/var/run|/run|' \
		src/common.h || die
}

src_compile() {
	emake ${PN} ${PN}d $(usex gd ${PN}i '')
}

src_install() {
	use gd && dobin vnstati
	dobin vnstat vnstatd

	exeinto /usr/share/${PN}
	newexe "${FILESDIR}"/vnstat.cron-r1 vnstat.cron

	insinto /etc
	doins cfg/vnstat.conf
	fowners root:vnstat /etc/vnstat.conf

	keepdir /var/lib/vnstat
	fowners vnstat:vnstat /var/lib/vnstat

	newconfd "${FILESDIR}"/vnstatd.confd-r1 vnstatd
	newinitd "${FILESDIR}"/vnstatd.initd-r2 vnstatd

	systemd_newunit "${FILESDIR}"/vnstatd.systemd vnstatd.service
	systemd_newtmpfilesd "${FILESDIR}"/vnstatd.tmpfile vnstatd.conf

	use gd && doman man/vnstati.1
	doman man/vnstat.1 man/vnstatd.1

	newdoc INSTALL README.setup
	dodoc CHANGES README UPGRADE FAQ examples/vnstat.cgi
}

pkg_postinst() {
	local _v
	for _v in ${REPLACING_VERSIONS}; do
		if ! version_is_at_least 1.17-r1 ${_v}; then
			# This is an upgrade
			elog ""
			elog "Beginning with ${PN}-1.17-r1, we no longer install and use the cron job"
			elog "per default to update vnStat databases because you will lose some traffic"
			elog "if your interface transfers more than ~4GB in the time between two cron"
			elog "runs".
			elog ""
			elog "Please make sure that the vnstatd service is enabled if you want to"
			elog "continue monitoring your traffic."

			# Show this elog only once
			break
		fi
	done

	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		# This is a new installation

		elog
		elog "Repeat the following command for every interface you"
		elog "wish to monitor (replace eth0):"
		elog "   vnstat -u -i eth0"
		elog "and set correct permissions after that, e.g."
		elog "   chown -R vnstat:vnstat /var/lib/vnstat"
		elog
		elog "It is highly recommended to use the included vnstatd to update your"
		elog "vnStat databases."
		elog
		elog "If you want to use the old cron way to update your vnStat databases,"
		elog "you have to install the cron job manually:"
		elog ""
		elog "   cp /usr/share/${PN}/vnstat.cron /etc/cron.hourly/vnstat"
		elog ""
		elog "Note: if an interface transfers more than ~4GB in"
		elog "the time between cron runs, you may miss traffic."
		elog "That's why using vnstatd instead of the cronjob is"
		elog "the recommended way to update your vnStat databases."
	fi
}
