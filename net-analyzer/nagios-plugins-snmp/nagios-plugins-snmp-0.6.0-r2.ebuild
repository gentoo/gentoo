# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Additional Nagios plugins for monitoring SNMP capable devices"
HOMEPAGE="http://nagios.manubulon.com"
SRC_URI="http://nagios.manubulon.com/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 ~sparc x86"

DEPEND="
	acct-group/nagios
	acct-user/nagios
	net-analyzer/net-snmp"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/nagios-plugins-snmp

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

src_prepare() {
	default
	sed -i -e '/^CFLAGS=""/d' configure.in || die
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf \
		--sysconfdir="${EPREFIX}"/etc/nagios \
		--libexec="${EPREFIX}"/usr/$(get_libdir)/nagios/plugins
}

src_install() {
	default

	fowners root:nagios /usr/$(get_libdir)/nagios/plugins
	fperms o-rwx /usr/$(get_libdir)/nagios/plugins
}
