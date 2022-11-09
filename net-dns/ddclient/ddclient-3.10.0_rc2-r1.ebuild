# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="${PV/rc/}"

inherit autotools optfeature systemd tmpfiles

DESCRIPTION="Perl client used to update dynamic DNS entries"
HOMEPAGE="https://ddclient.net/"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/v${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
LICENSE="GPL-2+"
SLOT="0"
IUSE="examples selinux test"
RESTRICT="!test? ( test )"

RDEPEND="
	acct-group/ddclient
	acct-user/ddclient
	dev-lang/perl
	dev-perl/Digest-SHA1
	dev-perl/IO-Socket-INET6
	dev-perl/IO-Socket-SSL
	virtual/perl-Digest-SHA
	virtual/perl-JSON-PP
	selinux? ( sec-policy/selinux-ddclient )
"

BDEPEND="
	test? (
		dev-perl/HTTP-Daemon
		dev-perl/HTTP-Daemon-SSL
		dev-perl/Plack
		dev-perl/Test-MockModule
		dev-perl/Test-Warnings
	)
"

src_prepare() {
	default

	# Remove PID setting, to reliably setup the environment for the init script
	sed -e '/^pid/d' -i ddclient.conf.in || die

	# Disable 'get_ip_from_if.pl' test, as it fails with network-sandbox
	# Don't create cache directory, as it's created by init script / tmpfiles
	sed -e '/get_ip_from_if.pl/d' -e '/MKDIR_P/d' -i Makefile.am || die

	# Remove windows executable
	if use examples; then
		rm sample-etc_dhcpc_dhcpcd-eth0.exe || die
	fi

	eautoreconf
}

src_install() {
	default

	newinitd "${FILESDIR}"/ddclient.initd-r7 ddclient
	systemd_newunit "${FILESDIR}"/ddclient.service-r2 ddclient.service
	newtmpfiles "${FILESDIR}"/ddclient.tmpfiles-r1 ddclient.conf

	if use examples; then
		docinto examples
		dodoc sample-*
	fi

	einstalldocs
}

pkg_postinst() {
	if [[ ${REPLACING_VERSIONS} ]]; then
		for v in ${REPLACING_VERSIONS}; do
			if ver_test "${v}" -lt 3.10.0; then
				if [ -f "${EROOT}/etc/ddclient/ddclient.conf" ]; then
					cp /etc/ddclient/ddclient.conf /etc/ddclient.conf || die
					ewarn "Your DDClient configuration has been copied from"
					ewarn "'/etc/ddclient/ddclient.conf' to '/etc/ddclient.conf'."
					ewarn "Please check your configuration."
				fi
				break
			fi
		done
	fi

	optfeature "using iproute2 instead if ifconfig." sys-apps/iproute2
	tmpfiles_process ddclient.conf
}
