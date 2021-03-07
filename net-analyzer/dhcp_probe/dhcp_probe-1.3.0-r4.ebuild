# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit flag-o-matic

DESCRIPTION="discover DHCP and BootP servers on a directly-attached Ethernet network"
HOMEPAGE="https://www.net.princeton.edu/software/dhcp_probe/"
SRC_URI="https://www.net.princeton.edu/software/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	net-libs/libpcap
	>=net-libs/libnet-1.1.2.1-r2
"
RDEPEND="${DEPEND}"
DOCS=(
	"${FILESDIR}"/${PN}_mail
	AUTHORS
	ChangeLog
	NEWS
	README
	TODO
	extras/dhcp_probe.cf.sample
)
PATCHES=(
	"${FILESDIR}"/${PV}/01_dhcp_probe.5.patch
	"${FILESDIR}"/${PV}/02_dhcp_probe.8.patch
	"${FILESDIR}"/${PV}/03_implicit_point_conv_bootp.c.patch
	"${FILESDIR}"/${PV}/04_linux_32_or_64bits.patch
	"${FILESDIR}"/${PV}/05-cleanup.patch
	"${FILESDIR}"/${PV}/06-return.patch
	"${FILESDIR}"/${PV}/07-comment.patch
	"${FILESDIR}"/${PV}/08-man8.patch
)

src_configure() {
	use amd64 && append-flags -D__ARCH__=64
	STRIP=true econf
}

src_install() {
	default

	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}
}
