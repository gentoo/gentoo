# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools systemd

DESCRIPTION="Network Information Service tools"
HOMEPAGE="https://www.thkukuk.de/nis/"
SRC_URI="https://github.com/thkukuk/yp-tools/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ia64 ~mips ppc ppc64 ~riscv ~sparc x86"
IUSE="nls"

DEPEND="
	net-libs/libtirpc:=
	>=net-libs/libnsl-1.2.0:0="
RDEPEND="${DEPEND}"
# always uses libtirpc if present

src_prepare() {
	default
	eautoreconf
}

src_configure () {
	econf \
		--disable-static \
		--sysconfdir="${EPREFIX}"/etc/yp \
		$(use_enable nls)
}

src_install() {
	default

	insinto /etc/yp
	doins etc/nicknames

	systemd_dounit "${FILESDIR}"/domainname.service
	systemd_install_serviced "${FILESDIR}"/domainname.service.conf
}
