# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit bash-completion-r1 systemd

DESCRIPTION="Security and system auditing tool"
HOMEPAGE="https://cisofy.com/lynis/"
SRC_URI="https://github.com/CISOfy/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+cron systemd"

RDEPEND="
	app-shells/bash
	cron? ( !systemd? ( virtual/cron ) )"

src_install() {
	doman lynis.8
	dodoc FAQ README
	newdoc CHANGELOG.md CHANGELOG

	# Remove the old one during the next stabilize progress
	exeinto /etc/cron.daily
	newexe "${FILESDIR}"/lynis.cron-new lynis

	dobashcomp extras/bash_completion.d/lynis

	# stricter default perms - bug 507436
	diropts -m0700
	insopts -m0600

	insinto /usr/share/${PN}
	doins -r db/ include/ plugins/

	dosbin lynis

	insinto /etc/${PN}
	doins default.prf
	sed -i -e 's/\/path\/to\///' "${S}/extras/systemd/${PN}.service" || die "Sed Failed!"
	systemd_dounit "${S}/extras/systemd/${PN}.service" || die "Sed Failed!"
	systemd_dounit "${S}/extras/systemd/${PN}.timer"

	if ! use cron; then
		ebegin "removing cron files from installation image"
		rm -rfv "${ED}/etc/cron.daily" || die
		eend "$?"
	fi
}

pkg_postinst() {
	if use cron; then
		if systemd_is_booted || has_version sys-apps/systemd; then
			echo
			ewarn "Both 'cron' and 'systemd' flags are enabled."
			ewarn "So both ${PN}.target and cron files were installed."
			ewarn "Please don't use 2 implementations at the same time."
			ewarn "Cronjobs are usually enabled by default via /etc/cron.* jobs"
			ewarn "If you want to use systemd ${PN}.target timers"
			ewarn "disable 'cron' flag and reinstall ${PN}"
			echo
		else
			einfo "A cron script has been installed to ${ROOT}/etc/cron.daily/lynis."
		fi
	fi
}
