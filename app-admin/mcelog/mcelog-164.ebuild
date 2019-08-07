# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-info systemd toolchain-funcs

DESCRIPTION="A tool to log and decode Machine Check Exceptions"
HOMEPAGE="http://mcelog.org/"
SRC_URI="https://github.com/andikleen/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="selinux"

RDEPEND="selinux? ( sec-policy/selinux-mcelog )"

# TODO: add mce-inject to the tree to support test phase
RESTRICT="test"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != buildonly ]]; then
		local CONFIG_CHECK="~X86_MCE"
		kernel_is -ge 4 12 && CONFIG_CHECK+=" ~X86_MCELOG_LEGACY"
		check_extra_config
	fi
}

src_prepare() {
	eapply "${FILESDIR}"/${PN}-0.8_pre1-timestamp-${PN}.patch \
		"${FILESDIR}"/${PN}-129-debugflags.patch
	eapply_user
	tc-export CC
}

src_install() {
	default

	insinto /etc/cron.daily
	newins ${PN}.cron ${PN}

	insinto /etc/logrotate.d/
	newins ${PN}.logrotate ${PN}

	newinitd "${FILESDIR}"/${PN}.init-r1 ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service

	dodoc *.pdf
}

pkg_postinst() {
	einfo "The default configuration set is now installed in /etc/${PN}"
	einfo "you might want to edit those files."
	einfo
	einfo "A sample cronjob is installed into /etc/cron.daily"
	einfo "without executable bit (system service is the preferred method now)"
}
