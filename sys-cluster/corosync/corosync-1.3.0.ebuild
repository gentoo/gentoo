# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/corosync/corosync-1.3.0.ebuild,v 1.5 2012/05/04 07:20:30 jdhore Exp $

EAPI=3

inherit base autotools

DESCRIPTION="OSI Certified implementation of a complete cluster engine"
HOMEPAGE="http://www.corosync.org/"
SRC_URI="ftp://ftp:${PN}.org@${PN}.org/downloads/${P}/${P}.tar.gz"

LICENSE="BSD-2 public-domain"
SLOT="0"
KEYWORDS="amd64 hppa x86"
IUSE="doc infiniband ssl"

RDEPEND="!sys-cluster/heartbeat
	ssl? ( dev-libs/nss )
	infiniband? (
		sys-infiniband/libibverbs
		sys-infiniband/librdmacm
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( sys-apps/groff )"

PATCHES=(
	"${FILESDIR}/${PN}-docs.patch"
)

DOCS=( "README.recovery" "README.devmap" "SECURITY" "TODO" "AUTHORS" )

src_prepare() {
	base_src_prepare
	eautoreconf
}

src_configure() {
	# appends lib to localstatedir automatically
	# FIXME: install both static and shared libs
	econf \
		--localstatedir=/var \
		--docdir=/usr/share/doc/${PF} \
		$(use_enable doc) \
		$(use_enable ssl nss) \
		$(use_enable infiniband rdma)
}

src_install() {
	base_src_install
	newinitd "${FILESDIR}"/${PN}.initd ${PN} || die

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN} || die

	keepdir /var/lib/corosync
}
