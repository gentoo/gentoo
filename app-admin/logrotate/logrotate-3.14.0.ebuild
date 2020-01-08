# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit systemd

DESCRIPTION="Rotates, compresses, and mails system logs"
HOMEPAGE="https://github.com/logrotate/logrotate"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${PV}/${P}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE="acl +cron selinux"

CDEPEND="
	>=dev-libs/popt-1.5
	selinux? ( sys-libs/libselinux )
	acl? ( virtual/acl )"

DEPEND="${CDEPEND}
	>=sys-apps/sed-4"

RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-logrotate )
	cron? ( virtual/cron )"

STATEFILE="/var/lib/misc/logrotate.status"
OLDSTATEFILE="/var/lib/logrotate.status"

move_old_state_file() {
	elog "logrotate state file is now located at ${STATEFILE}"
	elog "See bug #357275"
	if [[ -e "${OLDSTATEFILE}" ]] ; then
		elog "Moving your current state file to new location: ${STATEFILE}"
		mv -n "${OLDSTATEFILE}" "${STATEFILE}"
	fi
}

install_cron_file() {
	exeinto /etc/cron.daily
	newexe "${S}"/examples/logrotate.cron "${PN}"
}

PATCHES=(
	"${FILESDIR}/${P}-ignore-hidden.patch"
)

src_prepare() {
	sed -i -e 's#/usr/sbin/logrotate#/usr/bin/logrotate#' "${S}"/examples/logrotate.{cron,service} || die
	default
}

src_configure() {
	econf $(use_with acl) $(use_with selinux) --with-state-file-path="${STATEFILE}"
}

src_test() {
	emake test
}

src_install() {
	insinto /usr
	dobin logrotate
	doman logrotate.8
	dodoc ChangeLog.md examples/logrotate-default

	insinto /etc
	doins "${FILESDIR}"/logrotate.conf

	use cron && install_cron_file

	systemd_dounit examples/logrotate.{service,timer}
	systemd_newtmpfilesd "${FILESDIR}/${PN}.tmpfiles" "${PN}".conf

	keepdir /etc/logrotate.d
}

pkg_postinst() {
	elog
	elog "The ${PN} binary is now installed under /usr/bin. Please"
	elog "update your links"
	elog
	move_old_state_file
	elog "If you are running systemd you might need to run:"
	elog "systemd-tmpfiles --create /usr/lib/tmpfiles.d/logrotate.conf"
	elog "in order to create the new location of the logrotate state file"
	elog
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog "If you wish to have logrotate e-mail you updates, please"
		elog "emerge virtual/mailx and configure logrotate in"
		elog "/etc/logrotate.conf appropriately"
		elog
		elog "Additionally, /etc/logrotate.conf may need to be modified"
		elog "for your particular needs. See man logrotate for details."
	fi
}
