# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libnfsidmap/libnfsidmap-0.25.ebuild,v 1.2 2014/01/18 04:50:16 vapier Exp $

EAPI="4"

inherit autotools eutils multilib

DESCRIPTION="NFSv4 ID <-> name mapping library"
HOMEPAGE="http://www.citi.umich.edu/projects/nfsv4/linux/"
SRC_URI="http://www.citi.umich.edu/projects/nfsv4/linux/libnfsidmap/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="ldap static-libs"

DEPEND="ldap? ( net-nds/openldap )"
RDEPEND="${DEPEND}
	!<net-fs/nfs-utils-1.2.2
	!net-fs/idmapd"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.19-getgrouplist.patch #169909
	epatch "${FILESDIR}"/${PN}-0.21-headers.patch
	eautoreconf
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		$(use_enable static-libs static) \
		$(use_enable ldap)
}

src_install() {
	default

	insinto /etc
	doins idmapd.conf

	# remove useless files
	rm -f "${D}"/usr/$(get_libdir)/libnfsidmap/*.{a,la}
	use static-libs || find "${D}"/usr -name '*.la' -delete
}
