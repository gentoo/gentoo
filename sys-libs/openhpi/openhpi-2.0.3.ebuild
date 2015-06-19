# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/openhpi/openhpi-2.0.3.ebuild,v 1.4 2014/03/12 03:11:06 patrick Exp $

inherit flag-o-matic

DESCRIPTION="Open source implementation of the Service Availability Forum (SAF) Hardware Platform Interface (HPI)"
HOMEPAGE="http://openhpi.sourceforge.net/"
MY_P="${P}-1"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE="snmp examples"
RDEPEND=">=sys-fs/sysfsutils-1.0
	>=sys-libs/openipmi-0.26
	<sys-libs/openipmi-1.4
	snmp? ( >=net-analyzer/net-snmp-5.07 )"
DEPEND="${RDEPEND}
	virtual/os-headers"

src_compile() {
	local myconf
	myconf="${myconf} `use_enable snmp snmp_client`"
	myconf="${myconf} `use_enable snmp snmp_bc`"
	myconf="${myconf} `use_enable examples`"

	# these binaries are all system-core stuff
	# so I'm putting them into sbin
	econf \
		--bindir='/usr/sbin' \
		--with-confpath=/etc/openhpi/ \
		--with-varpath=/var/lib/openhpi/ \
		--enable-thread \
		--enable-daemon \
		--enable-shell_client \
		--enable-dummy \
		--enable-watchdog \
		--enable-ipmi \
		--enable-sysfs \
		--enable-ipmidirect \
		--enable-remote_client \
		--enable-simulator \
		--disable-testcover \
		${myconf} \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	dodoc COPYING README
	emake \
		DESTDIR="${D}" \
		docdir="/usr/share/doc/${PF}" \
		mkinstalldirs="mkdir -pv" \
		install install-data-local \
		|| die "emake install failed"
	cd ${S}/examples
	emake \
		DESTDIR="${D}" \
		docdir="/usr/share/doc/${PF}" \
		mkinstalldirs="mkdir -pv" \
		install-data-local \
		|| die "emake install-data-local for config failed"
	if use examples; then
		dodoc list_resources*.c
		newsbin list_resources hpi_list_resources
		[ -f list_resources_threaded ] && newsbin list_resources_threaded hpi_list_resources_threaded
	fi
	keepdir /var/lib/openhpi/
}
