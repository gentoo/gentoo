# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit readme.gentoo-r1 systemd

DESCRIPTION="Arno's iptables firewall script"
HOMEPAGE="https://rocky.eld.leidenuniv.nl https://github.com/arno-iptables-firewall/aif"

SRC_URI="https://github.com/${PN}/aif/archive/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/aif-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+plugins rsyslog"

RDEPEND="
	net-firewall/ipset
	net-firewall/iptables
	sys-apps/coreutils
	sys-apps/iproute2
	plugins? ( net-dns/bind-tools )
"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="You will need to configure /etc/${PN}/firewall.conf
before using this package. To start the script, run:

/etc/init.d/${PN} start (for OpenRC)
systemctl start ${PN} (for systemd)

If you want to start this script at boot, run:

rc-update add ${PN} default (for OpenRC)
systemctl enable ${PN} (for systemd)"

src_prepare() {
	sed -i -e 's:/usr/local/share/:/usr/libexec/:' \
		bin/"${PN}" share/"${PN}"/environment || die "Sed failed!"
	sed -i -e 's:/usr/local/sbin/:/usr/sbin/:' \
		lib/systemd/system/"${PN}.service" || die "Sed failed!"
	eapply_user
}

src_install() {
	insinto /etc/"${PN}"
	doins etc/"${PN}"/firewall.conf
	doins etc/"${PN}"/custom-rules

	doinitd "${FILESDIR}/${PN}"
	systemd_dounit lib/systemd/system/"${PN}.service"

	dobin bin/arno-fwfilter
	dosbin bin/"${PN}"

	insinto /usr/libexec/"${PN}"
	doins share/"${PN}"/environment

	exeinto /usr/libexec/"${PN}"
	doexe share/"${PN}"/aif-job-execute
	doexe share/"${PN}"/aif-job-processor

	insinto /etc/logrotate.d
	doins etc/logrotate.d/"${PN}"

	dodoc CHANGELOG README
	readme.gentoo_create_doc

	if use plugins
	then
		insinto /etc/"${PN}"/plugins
		doins etc/"${PN}"/plugins/*

		insinto /usr/libexec/"${PN}"/plugins
		doins share/"${PN}"/plugins/*.plugin
		doins share/"${PN}"/plugins/adaptive-ban-helper
		doins share/"${PN}"/plugins/dyndns-host-open-helper
		doins share/"${PN}"/plugins/parasitic-net-helper
		doins share/"${PN}"/plugins/traffic-accounting-helper

		exeinto /usr/libexec/"${PN}"/plugins
		doexe share/"${PN}"/plugins/traffic-accounting-log-rotate
		doexe share/"${PN}"/plugins/traffic-accounting-show

		docinto plugins
		dodoc share/"${PN}"/plugins/*.CHANGELOG
	fi

	if use rsyslog
	then
		insinto /etc/rsyslog.d
		newins etc/rsyslog.d/"${PN}".conf 20-"${PN}".conf
	fi

	doman share/man/man1/arno-fwfilter.1 \
		share/man/man8/"${PN}".8
}

pkg_postinst() {
	ewarn "When you stop this script, all firewall rules are flushed!"
	ewarn "Make sure to not use multiple firewall scripts simultaneously"
	ewarn "unless you know what you are doing!"
	readme.gentoo_print_elog
}
