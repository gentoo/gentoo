# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="Netkit - bootparamd"
HOMEPAGE="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/"
SRC_URI="mirror://debian/pool/main/n/netkit-bootparamd/${PN}_${PV}.orig.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~hppa ~mips ppc sparc x86"
IUSE=""

DEPEND="!<=net-misc/netkit-bootpd-0.17-r2"
RDEPEND=${DEPEND}

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/0.17-jumpstart.patch
}

src_compile() {
	# Note this is not an autoconf configure
	./configure || die "configure failed"
	emake || die "make failed"
}

src_install() {
	into /usr
	dosbin rpc.bootparamd/bootparamd || die "installing binary failed"
	dosym bootparamd /usr/sbin/rpc.bootparamd
	doman rpc.bootparamd/bootparamd.8
	dosym bootparamd.8.gz /usr/share/man/man8/rpc.bootparamd.8.gz
	doman rpc.bootparamd/bootparams.5
	dodoc README ChangeLog
	newdoc rpc.bootparamd/README README.bootparamd
}
