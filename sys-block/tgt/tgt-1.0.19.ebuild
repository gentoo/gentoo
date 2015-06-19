# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/tgt/tgt-1.0.19.ebuild,v 1.2 2015/04/01 22:24:56 dilfridge Exp $

EAPI=4

inherit flag-o-matic linux-info

DESCRIPTION="Linux SCSI target framework (tgt)"
HOMEPAGE="http://stgt.sourceforge.net"
SRC_URI="http://stgt.sourceforge.net/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ibmvio infiniband fcp fcoe"

DEPEND="dev-perl/Config-General
	infiniband? (
		sys-infiniband/libibverbs
		sys-infiniband/librdmacm
	)"
RDEPEND="${DEPEND}
	sys-apps/sg3_utils"

pkg_setup() {
	CONFIG_CHECK="~SCSI_TGT"
	WARNING_SCSI_TGT="Your kernel needs CONFIG_SCSI_TGT"
	linux-info_pkg_setup
}

src_configure() {
	use ibmvio && myconf="${myconf} IBMVIO=1"
	use infiniband && myconf="${myconf} ISCSI_RDMA=1"
	use fcp && myconf="${myconf} FCP=1"
	use fcoe && myconf="${myconf} FCOE=1"

	sed -e 's:\($(CC)\):\1 $(LDFLAGS):' -i usr/Makefile || die "sed failed"
}

src_compile() {
	emake -C usr/ KERNELSRC="${KERNEL_DIR}" ISCSI=1 ${myconf}
}

src_install() {
	emake  install-programs install-scripts install-doc DESTDIR="${D}" \
		docdir=/usr/share/doc/${PF}
	doinitd "${FILESDIR}/tgtd"
	dodir /etc/tgt
	keepdir /etc/tgt
}
