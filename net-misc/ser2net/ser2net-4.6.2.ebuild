# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Serial To Network Proxy"
HOMEPAGE="https://sourceforge.net/projects/ser2net"
SRC_URI="https://downloads.sourceforge.net/ser2net/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pam"

DEPEND="
	dev-libs/libyaml:=
	net-misc/gensio
	pam? ( sys-libs/pam )
"
RDEPEND="${DEPEND}"

# Test suite requires a kernel module
RESTRICT="test"

src_configure() {
	econf --without-sysfs-led-support $(use_with pam)
}

src_install() {
	default

	insinto /etc/${PN}
	doins ${PN}.yaml

	newinitd "${FILESDIR}/${PN}.initd-r2" ${PN}
	newconfd "${FILESDIR}/${PN}.confd-r2" ${PN}
}
