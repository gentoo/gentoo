# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit readme.gentoo systemd versionator

DESCRIPTION="Arno's iptables firewall script"
HOMEPAGE="http://rocky.eld.leidenuniv.nl"

MY_PV=$(replace_version_separator 3 -)
SRC_URI="http://rocky.eld.leidenuniv.nl/${PN}/${PN}_${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+plugins"

# sys-apps/coreutils dependency wrt
# https://bugs.gentoo.org/show_bug.cgi?id=448716

DEPEND=""
RDEPEND="net-firewall/iptables
		>sys-apps/coreutils-8.20-r1
		sys-apps/iproute2
		plugins? ( net-dns/bind-tools )"

S="${WORKDIR}/${PN}_${MY_PV/rc/RC}"

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
		etc/"${PN}"/firewall.conf || die "Sed failed!"
	sed -i -e 's:/usr/local/sbin/:/usr/sbin/:' \
		lib/systemd/system/"${PN}.service" || die "Sed failed!"
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

	dodoc CHANGELOG README
	readme.gentoo_create_doc

	if use plugins
	then
		insinto /etc/"${PN}"/plugins
		doins etc/"${PN}"/plugins/*

		insinto /usr/libexec/"${PN}"/plugins
		doins share/"${PN}"/plugins/*.plugin

		exeinto /usr/libexec/"${PN}"/plugins
		doexe share/"${PN}"/plugins/dyndns-host-open-helper
		doexe share/"${PN}"/plugins/traffic-accounting-helper
		doexe share/"${PN}"/plugins/traffic-accounting-log-rotate
		doexe share/"${PN}"/plugins/traffic-accounting-show

		docinto plugins
		dodoc share/"${PN}"/plugins/*.CHANGELOG
	fi

	doman share/man/man1/arno-fwfilter.1 \
		share/man/man8/"${PN}".8
}

pkg_postinst () {
	ewarn "When you stop this script, all firewall rules are flushed!"
	ewarn "Make sure to not use multiple firewall scripts simultaneously"
	ewarn "unless you know what you are doing!"
	readme.gentoo_print_elog
}
