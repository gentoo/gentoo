# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit flag-o-matic toolchain-funcs

MY_TREE="eca74a7"

DESCRIPTION="Linux SCSI target framework (tgt)"
HOMEPAGE="http://stgt.sourceforge.net"
SRC_URI="https://github.com/fujita/tgt/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="fcoe fcp ibmvio infiniband rbd"

CDEPEND="dev-perl/Config-General
	dev-libs/libxslt
	rbd? ( sys-cluster/ceph )
	infiniband? (
		sys-infiniband/libibverbs:=
		sys-infiniband/librdmacm:=
	)"
DEPEND="${CDEPEND}
	app-text/docbook-xsl-stylesheets"
RDEPEND="${DEPEND}
	dev-libs/libaio
	sys-apps/sg3_utils"

S=${WORKDIR}/fujita-tgt-${MY_TREE}

pkg_setup() {
	tc-export CC
}

src_prepare() {
	sed -i -e 's:\($(CC)\) $^:\1 $(LDFLAGS) $^:' usr/Makefile || die

	# make sure xml docs are generated before trying to install them
	sed -i -e "s@install: @& all @g" doc/Makefile || die
}

src_compile() {
	local myconf
	use ibmvio && myconf="${myconf} IBMVIO=1"
	use infiniband && myconf="${myconf} ISCSI_RDMA=1"
	use fcp && myconf="${myconf} FCP=1"
	use fcoe && myconf="${myconf} FCOE=1"
	use rbd && myconf="${myconf} CEPH_RBD=1"

	emake -C usr/ KERNELSRC="${KERNEL_DIR}" ISCSI=1 ${myconf}
	emake -C doc
}

src_install() {
	emake  install-programs install-scripts install-doc DESTDIR="${D}" docdir=/usr/share/doc/${PF}
	newinitd "${FILESDIR}"/tgtd.initd tgtd
	newconfd "${FILESDIR}"/tgtd.confd tgtd
	dodir /etc/tgt
	keepdir /etc/tgt
}
