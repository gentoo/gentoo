# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/gfs2-utils/gfs2-utils-3.1.3.ebuild,v 1.1 2013/03/20 14:17:56 ultrabug Exp $

EAPI=4

inherit autotools linux-info

DESCRIPTION="GFS2 Utilities"
HOMEPAGE="https://fedorahosted.org/cluster/wiki/HomePage"
SRC_URI="https://fedorahosted.org/releases/${PN:0:1}/${PN:1:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="sys-cluster/corosync
	sys-cluster/openais
	sys-cluster/liblogthread
	sys-cluster/libccs
	sys-cluster/libfence
	sys-cluster/libdlm
	sys-libs/ncurses"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${PN}"

src_prepare() {
	mkdir m4
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		--with-kernel="${KERNEL_DIR}" \
		--localstatedir=/var
}

src_install() {
	default
	rm -rf "${D}/usr/share/doc"
	dodoc doc/*.txt

	rmdir "${D}"/var/run/{cluster,} # cman-init.d creates it

	keepdir /var/{lib,log}/cluster
}
