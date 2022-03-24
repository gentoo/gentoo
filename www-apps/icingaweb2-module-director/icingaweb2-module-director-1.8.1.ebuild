# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Icinga Web 2 plugin for configuration"
HOMEPAGE="https://dev.icinga.org/projects/icingaweb2-module-director/"
inherit systemd
if [[ "${PV}" == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Icinga/icingaweb2-module-director.git"
else
	KEYWORDS="amd64 x86"
	MY_PN="icingaweb2-module-director"
	SRC_URI="https://codeload.github.com/Icinga/${MY_PN}/tar.gz/v${PV} -> ${P}.tar.gz"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

LICENSE="GPL-2"
SLOT="0"

DEPEND=">=net-analyzer/icinga2-2.6.0
	>=www-apps/icingaweb2-2.6.0
	|| (
		dev-lang/php:7.3[curl,iconv,pcntl,posix,sockets]
		dev-lang/php:7.4[curl,iconv,pcntl,posix,sockets]
		dev-lang/php:8.0[curl,iconv,pcntl,posix,sockets]
	)
	acct-group/icingaweb2
	acct-user/icingadirector"
RDEPEND="${DEPEND}"

src_install() {
	insinto "/usr/share/icingaweb2/modules/director/"
	doins -r "${S}"/*
	keepdir /var/lib/${PN}
	fowners icingadirector:icingaweb2 /var/lib/${PN}
	fperms 0750 /var/lib/${PN}
	sed -e "s|/usr/bin/icingacli|/usr/share/icingaweb2/bin/icingacli|g" \
		contrib/systemd/icinga-director.service > "${T}/icinga-director.service" \
		|| die "failed to patch icinga-director.service"
	systemd_dounit "${T}/icinga-director.service"
}

pkg_postinst() {
	elog "Enable and start the icinga-director.service systemd service."
}
