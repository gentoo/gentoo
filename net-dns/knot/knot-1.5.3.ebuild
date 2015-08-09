# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGIT_REPO_URI="https://gitlab.labs.nic.cz/labs/${PN}.git"
[[ ${PV} == 9999 ]] && inherit autotools git-r3
inherit eutils user

DESCRIPTION="High-performance authoritative-only DNS server"
HOMEPAGE="http://www.knot-dns.cz/"
[[ ${PV} == 9999 ]] || SRC_URI="https://secure.nic.cz/files/knot-dns/${P/_/-}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
[[ ${PV} == 9999 ]] || \
KEYWORDS="~amd64 ~x86"
IUSE="debug caps +fastparser idn"

RDEPEND="
	dev-libs/openssl
	dev-libs/userspace-rcu
	caps? ( sys-libs/libcap-ng )
	idn? ( net-dns/libidn )
"
#	sys-libs/glibc
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/flex
	virtual/yacc
	fastparser? ( dev-util/ragel )
"

S="${WORKDIR}/${P/_/-}"

src_prepare() {
	[[ ${PV} == 9999 ]] && eautoreconf
}

src_configure() {
	econf \
		--with-storage="${EPREFIX}/var/lib/${PN}" \
		--with-rundir="${EPREFIX}/var/run/${PN}" \
		--disable-lto \
		--enable-recvmmsg \
		$(use_enable fastparser) \
		$(use_enable debug debug server,zones,xfr,packet,dname,rr,ns,hash,compiler) \
		$(use_enable debug debuglevel details) \
		$(use_with idn libidn)
}

src_install() {
	default
	newinitd "${FILESDIR}/knot.init" knot
}

pkg_postinst() {
	enewgroup knot 53
	enewuser knot 53 -1 /var/lib/knot knot
}
