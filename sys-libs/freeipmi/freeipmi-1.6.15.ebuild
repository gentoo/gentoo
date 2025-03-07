# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

MY_P="${P/_/.}"
DESCRIPTION="Provides Remote-Console and System Management Software as per IPMI v1.5/2.0"
HOMEPAGE="https://www.gnu.org/software/freeipmi/"
SRC_URI="mirror://gnu/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~hppa ~ppc64 x86"
IUSE="debug doc nagios without-root"

RDEPEND="dev-libs/libgcrypt:="
DEPEND="
	${RDEPEND}
	virtual/os-headers
"
RDEPEND="
	${RDEPEND}
	nagios? (
		|| ( net-analyzer/icinga net-analyzer/nagios )
		dev-lang/perl
	)
"

src_configure() {
	# bug #943813
	append-cflags -std=gnu17

	local myeconfargs=(
		$(use_enable debug)
		$(use_enable doc)
		$(usev without-root --with-dont-check-for-root)
		--disable-static
		--disable-init-scripts
		--localstatedir="${EPREFIX}"/var
		ac_cv_path_CPP_FOR_BUILD="$(tc-getPROG CPP cpp)"
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	# freeipmi by defaults install _all_ commands to /usr/sbin, but
	# quite a few can be run remotely as standard user, so move them
	# in /usr/bin afterwards.
	dodir /usr/bin
	local prog
	for prog in ipmi{detect,ping,power,console}; do
		mv "${ED}"/usr/{s,}bin/${prog} || die

		# The default install symlinks these commands to add a dash
		# after the ipmi prefix; we repeat those after move for
		# consistency.
		rm "${ED}"/usr/sbin/${prog/ipmi/ipmi-}
		dosym ${prog} /usr/bin/${prog/ipmi/ipmi-}
	done

	# Install the nagios plugin in its proper place, if desired
	if use nagios; then
		dodir /usr/$(get_libdir)/nagios/plugins
		mv "${ED}"/usr/share/doc/${PF}/contrib/nagios/nagios_ipmi_sensors.pl \
			"${ED}"/usr/$(get_libdir)/nagios/plugins/ || die
		fperms 0755 /usr/$(get_libdir)/nagios/plugins/nagios_ipmi_sensors.pl

		insinto /etc/icinga/conf.d
		newins "${FILESDIR}"/freeipmi.icinga freeipmi-command.cfg
	fi

	dodoc AUTHORS ChangeLog* DISCLAIMER* NEWS README* TODO doc/*.txt

	keepdir \
		/var/cache/ipmiseld \
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

	find "${ED}" -type f -name "*.la" -delete || die
}
