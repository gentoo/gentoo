# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic systemd toolchain-funcs

DESCRIPTION="Standard log daemons"
HOMEPAGE="https://troglobit.com/sysklogd.html https://github.com/troglobit/sysklogd"
SRC_URI="https://github.com/troglobit/sysklogd/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="logger logrotate systemd"
RESTRICT="test"

DEPEND="
	logger? (
		!<sys-apps/util-linux-2.34-r3
		!>=sys-apps/util-linux-2.34-r3[logger]
	)
"
RDEPEND="${DEPEND}"

DOCS=( ChangeLog.md README.md )

pkg_setup() {
	append-lfs-flags
	tc-export CC
}

src_configure() {
	local myeconfargs=(
		--runstatedir="${EPREFIX}"/run
		$(use_with logger)
		$(use_with systemd systemd $(systemd_get_systemunitdir))
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	insinto /etc
	doins syslog.conf
	keepdir /etc/syslog.d

	newinitd "${FILESDIR}"/sysklogd.rc10 sysklogd
	newconfd "${FILESDIR}"/sysklogd.confd3 sysklogd

	if use logrotate ; then
		insinto /etc/logrotate.d
		newins "${FILESDIR}"/sysklogd.logrotate sysklogd
		sed 's@ -r 10M:10@@' -i "${ED}"/etc/conf.d/sysklogd || die
	fi

	find "${ED}" -type f \( -name "*.a" -o -name "*.la" \) -delete || die
}

pkg_postinst() {
	if ! use logrotate && [[ -n ${REPLACING_VERSIONS} ]] && ver_test ${REPLACING_VERSIONS} -lt 2.0 ; then
		elog "Starting with version 2.0 syslogd has built in log rotation"
		elog "functionality that does no longer require a running cron daemon."
		elog "So we no longer install any log rotation cron files for sysklogd."
	fi
	if [[ -n ${REPLACING_VERSIONS} ]] && ver_test ${REPLACING_VERSIONS} -lt 2.1 ; then
		elog "Starting with version 2.1 sysklogd no longer provides klogd."
		elog "syslogd now also logs kernel messages."
	fi
}
