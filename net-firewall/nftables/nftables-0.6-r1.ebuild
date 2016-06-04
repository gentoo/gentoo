# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools linux-info systemd

DESCRIPTION="Linux kernel (3.13+) firewall, NAT and packet mangling tools"
HOMEPAGE="http://netfilter.org/projects/nftables/"
SRC_URI="http://git.netfilter.org/nftables/snapshot/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug doc gmp +readline"

RDEPEND=">=net-libs/libmnl-1.0.3
	>=net-libs/libnftnl-1.0.6
	gmp? ( dev-libs/gmp:0= )
	readline? ( sys-libs/readline:0= )"
DEPEND="${RDEPEND}
	>=app-text/docbook2X-0.8.8-r4
	doc? ( >=app-text/dblatex-0.3.7 )
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig"

S="${WORKDIR}/v${PV}"

PATCHES=( "${FILESDIR}/${PN}-0.5-pdf-doc.patch" )

pkg_setup() {
	if kernel_is ge 3 13; then
		CONFIG_CHECK="~NF_TABLES"
		linux-info_pkg_setup
	else
		eerror "This package requires kernel version 3.13 or newer to work properly."
	fi
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--sbindir="${EPREFIX}"/sbin \
		$(use_enable doc pdf-doc) \
		$(use_enable debug) \
		$(use_with readline cli) \
		$(use_with !gmp mini_gmp)
}

src_install() {
	default

	dodir /usr/libexec/${PN}
	exeinto /usr/libexec/${PN}
	doexe "${FILESDIR}"/libexec/${PN}.sh

	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.init ${PN}
	keepdir /var/lib/nftables

	systemd_dounit "${FILESDIR}"/systemd/${PN}-restore.service
	systemd_enable_service basic.target ${PN}-restore.service
}

pkg_postinst() {
	local save_file
	save_file="${EROOT}var/lib/nftables/rules-save"

	elog "In order for the nftables-restore systemd service to start, "
	elog "the file, ${save_file}, must exist.  To create this "
	elog "file run the following command: "
	elog ""
	elog "	touch '${save_file}'"
	elog ""
	elog "Afterwards, the nftables-restore service should be manually started "
	elog "to ensure firewall changes are stored on system shutdown.  The "
	elog "systemd service will function normally thereafter."
}
