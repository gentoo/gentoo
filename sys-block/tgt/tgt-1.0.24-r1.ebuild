# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/tgt/tgt-1.0.24-r1.ebuild,v 1.3 2015/04/01 22:24:56 dilfridge Exp $

EAPI=4

inherit flag-o-matic linux-info toolchain-funcs

MY_TREE="e039354"

DESCRIPTION="Linux SCSI target framework (tgt)"
HOMEPAGE="http://stgt.sourceforge.net"
SRC_URI="https://github.com/fujita/tgt/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ibmvio infiniband fcp fcoe"

CDEPEND="dev-perl/Config-General
	dev-libs/libxslt
	infiniband? (
		sys-infiniband/libibverbs
		sys-infiniband/librdmacm
	)"
DEPEND="${CDEPEND}
	app-text/docbook-xsl-stylesheets"
RDEPEND="${DEPEND}
	sys-apps/sg3_utils"

S=${WORKDIR}/fujita-tgt-${MY_TREE}

pkg_setup() {
	CONFIG_CHECK="~SCSI_TGT"
	WARNING_SCSI_TGT="Your kernel needs CONFIG_SCSI_TGT"
	linux-info_pkg_setup
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

	emake -C usr/ KERNELSRC="${KERNEL_DIR}" ISCSI=1 ${myconf}
	emake -C doc
}

src_install() {
	emake  install-programs install-scripts install-doc DESTDIR="${D}" \
		docdir=/usr/share/doc/${PF}
	newinitd "${FILESDIR}"/tgtd-${PV}.initd tgtd
	newconfd "${FILESDIR}"/tgtd-${PV}.confd tgtd
	dodir /etc/tgt
	keepdir /etc/tgt
}
