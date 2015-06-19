# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/s390-tools/s390-tools-1.17.0.ebuild,v 1.3 2014/01/14 23:37:08 vapier Exp $

EAPI="4"

inherit eutils udev

# look at zfcpdump_v2/README
E2FSPROGS_P=e2fsprogs-1.41.3
LINUX_P=linux-2.6.27

DESCRIPTION="User space utilities for the zSeries (s390) Linux kernel and device drivers"
HOMEPAGE="http://www.ibm.com/developerworks/linux/linux390/s390-tools.html"
SRC_URI="http://download.boulder.ibm.com/ibmdl/pub/software/dw/linux390/ht_src/${P}.tar.bz2
	zfcpdump? (
		mirror://sourceforge/e2fsprogs/${E2FSPROGS_P}.tar.gz
		mirror://kernel/linux/kernel/v2.6/${LINUX_P}.tar.bz2
	)"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* s390"
IUSE="fuse snmp zfcpdump"

RDEPEND="fuse? ( sys-fs/fuse )
	snmp? ( net-analyzer/net-snmp )"
DEPEND="${RDEPEND}
	dev-util/indent
	app-admin/genromfs"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.16.0-build.patch

	use snmp || sed -i -e 's:osasnmpd::' Makefile
	use fuse || { sed -i -e 's:cmsfs-fuse::' Makefile; export WITHOUT_FUSE=1; }

	if use zfcpdump ; then
		local x
		for x in ${E2FSPROGS_P}.tar.gz ${LINUX_P}.tar.bz2 ; do
			ln -s "${DISTDIR}"/${x} zfcpdump_v2/${x} || die "ln ${x}"
		done
		sed -i -e '/^ZFCPDUMP_DIR/s:local/::' common.mak
		sed -i -e '/^SUB_DIRS/s:=:=zfcpdump_v2 :' Makefile
	fi

	export MAKEOPTS+=" V=1"
}

src_install() {
	emake install INSTROOT="${D}" USRBINDIR="${D}/sbin"
	dodoc README
	udev_dorules etc/udev/rules.d/*.rules
}
