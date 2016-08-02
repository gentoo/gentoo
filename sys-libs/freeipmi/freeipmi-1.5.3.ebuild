# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

AT_M4DIR="config"

inherit eutils multilib

DESCRIPTION="Provides Remote-Console and System Management Software as per IPMI v1.5/2.0"
HOMEPAGE="https://www.gnu.org/software/freeipmi/"

MY_P="${P/_/.}"
S="${WORKDIR}"/${MY_P}
[[ ${MY_P} == *.beta* ]] && ALPHA="-alpha"
SRC_URI="mirror://gnu${ALPHA}/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug nagios"

RDEPEND="dev-libs/libgcrypt:0"
DEPEND="${RDEPEND}
		virtual/os-headers"
RDEPEND="${RDEPEND}
	nagios? (
		|| ( net-analyzer/icinga net-analyzer/nagios )
		dev-lang/perl
	)
	sys-apps/openrc"

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		--disable-static
		--disable-init-scripts
		--localstatedir=/var
	)

	econf "${myeconfargs[@]}"
}

# There are no tests
src_test() { :; }

src_install() {
	default

	# freeipmi by defaults install _all_ commands to /usr/sbin, but
	# quite a few can be run remotely as standard user, so move them
	# in /usr/bin afterwards.
	dodir /usr/bin
	for file in ipmi{detect,ping,power,console}; do
		mv "${D}"/usr/{s,}bin/${file} || die

		# The default install symlinks these commands to add a dash
		# after the ipmi prefix; we repeat those after move for
		# consistency.
		rm "${D}"/usr/sbin/${file/ipmi/ipmi-}
		dosym ${file} /usr/bin/${file/ipmi/ipmi-}
	done

	# Install the nagios plugin in its proper place, if desired
	if use nagios; then
		dodir /usr/$(get_libdir)/nagios/plugins
		mv "${D}"/usr/share/doc/${PF}/contrib/nagios/nagios_ipmi_sensors.pl \
			"${D}"/usr/$(get_libdir)/nagios/plugins/ || die
		fperms 0755 /usr/$(get_libdir)/nagios/plugins/nagios_ipmi_sensors.pl

		insinto /etc/icinga/conf.d
		newins "${FILESDIR}"/freeipmi.icinga freeipmi-command.cfg
	fi

	dodoc AUTHORS ChangeLog* DISCLAIMER* NEWS README* TODO doc/*.txt

	keepdir \
		/var/cache/ipmimonitoringsdrcache \
		/var/lib/freeipmi \
		/var/log/ipmiconsole

	# starting from version 1.2.0 the two daemons are similar enough
	newinitd "${FILESDIR}"/bmc-watchdog.initd.4 ipmidetectd
	newconfd "${FILESDIR}"/ipmidetectd.confd ipmidetectd

	newinitd "${FILESDIR}"/bmc-watchdog.initd.4 bmc-watchdog
	newconfd "${FILESDIR}"/bmc-watchdog.confd bmc-watchdog

	newinitd "${FILESDIR}"/bmc-watchdog.initd.4 ipmiseld
	newconfd "${FILESDIR}"/ipmiseld.confd ipmiseld
}
