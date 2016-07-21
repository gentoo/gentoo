# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit eutils toolchain-funcs

DESCRIPTION="Netkit - bootparamd"
HOMEPAGE="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/"
SRC_URI="mirror://debian/pool/main/n/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~hppa ~mips ppc sparc x86"
IUSE=""

DEPEND="!<=net-misc/netkit-bootpd-0.17-r2"
RDEPEND=${DEPEND}

src_prepare() {
	epatch "${FILESDIR}"/0.17-jumpstart.patch

	# don't reset LDFLAGS (bug #335457), manpages into /usr/share/man
	sed -i -e '/^LDFLAGS=/d ; /MANDIR=/s:man:share/man:' configure || die

	sed -i -e 's:install -s:install:' rpc.bootparamd/Makefile || die
}

src_configure() {
	# Note this is not an autoconf configure
	CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}" ./configure || die
}

src_install() {
	dodir usr/bin usr/sbin usr/share/man/man8 || die
	emake INSTALLROOT="${D}" install || die

	newconfd "${FILESDIR}"/bootparamd.confd bootparamd || die
	newinitd "${FILESDIR}"/bootparamd.initd bootparamd || die

	doman rpc.bootparamd/bootparams.5 || die
	dodoc README ChangeLog || die
	newdoc rpc.bootparamd/README README.bootparamd || die
}
