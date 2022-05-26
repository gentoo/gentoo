# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Simple port-knocking daemon"
HOMEPAGE="https://www.zeroflux.org/projects/knock"
SRC_URI="https://www.zeroflux.org/proj/knock/files/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="+server"

DEPEND="server? ( net-libs/libpcap )"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	sed -e "/^AM_CFLAGS/s: -g : :" \
		-e "/dist_doc_DATA/s:COPYING::" \
		-i Makefile.in || die

	sed -e "s:/usr/sbin/iptables:/sbin/iptables:g" \
		-i knockd.conf || die
}

src_configure() {
	econf $(use_enable server knockd)
}

src_install() {
	emake DESTDIR="${D}" docdir="${EPREFIX}/usr/share/doc/${PF}" install

	if use server ; then
		newinitd "${FILESDIR}"/knockd.initd.2 knock
		newconfd "${FILESDIR}"/knockd.confd.2 knock
	fi
}

pkg_postinst() {
	if use server && ! has_version net-firewall/iptables ; then
		elog "You're really encouraged to install net-firewall/iptables to"
		elog "actually modify your firewall and use the example configuration."
	fi
}
