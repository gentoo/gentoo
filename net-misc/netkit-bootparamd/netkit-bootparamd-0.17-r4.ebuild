# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs flag-o-matic

DESCRIPTION="Netkit - bootparamd"
HOMEPAGE="http://ftp.linux.org.uk/pub/linux/Networking/netkit/"
SRC_URI="mirror://debian/pool/main/n/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ~mips ppc sparc x86"
IUSE="+libtirpc"

DEPEND="
	!<=net-misc/netkit-bootpd-0.17-r2
	libtirpc? ( net-libs/rpcsvc-proto net-libs/libtirpc )
	!libtirpc? ( sys-libs/glibc[rpc(-)] )
"
RDEPEND=${DEPEND}

src_prepare() {
	eapply "${FILESDIR}"/0.17-jumpstart.patch
	eapply "${FILESDIR}"/0.17-libtirpc.patch

	# don't reset LDFLAGS (bug #335457), manpages into /usr/share/man
	sed -i -e '/^LDFLAGS=/d ; /MANDIR=/s:man:share/man:' configure || die

	sed -i -e 's:install -s:install:' rpc.bootparamd/Makefile || die

	default
}

src_configure() {
	if use libtirpc ; then
		append-cflags -I/usr/include/tirpc
		sed -i -e 's:^LIBS=$:LIBS=-ltirpc:' configure || die
	fi

	# Note this is not an autoconf configure
	CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}" CFLAGS="${CFLAGS}" ./configure || die
}

src_install() {
	dodir usr/bin usr/sbin usr/share/man/man8
	emake INSTALLROOT="${D}" install

	newconfd "${FILESDIR}"/bootparamd.confd bootparamd
	newinitd "${FILESDIR}"/bootparamd.initd bootparamd

	doman rpc.bootparamd/bootparams.5
	dodoc README ChangeLog
	newdoc rpc.bootparamd/README README.bootparamd
}
