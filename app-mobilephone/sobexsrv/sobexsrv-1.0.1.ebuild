# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-mobilephone/sobexsrv/sobexsrv-1.0.1.ebuild,v 1.11 2012/06/02 05:04:06 zmedico Exp $

inherit eutils toolchain-funcs user

MY_P="${P/_pre/pre}"

IUSE="gtk"

DESCRIPTION="Scripting/Secure OBEX Server (for BlueZ Linux)"
SRC_URI="http://www.mulliner.org/bluetooth/${MY_P}.tar.gz
	 http://dev.gentoo.org/~joker/${P}-fix64.patch"
HOMEPAGE="http://www.mulliner.org/bluetooth/sobexsrv.php"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"

DEPEND="dev-libs/openobex
	net-wireless/bluez"
RDEPEND="${DEPEND}
	gtk? ( >=dev-python/pygtk-2.2 )"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	enewgroup sobexsrv
	enewuser sobexsrv -1 -1 /var/spool/sobexsrv sobexsrv
}

src_unpack() {
	unpack ${A}

	cd "${S}"

	epatch "${DISTDIR}/${P}"-fix64.patch || die "fix64 patch failed"

	sed -e 's:/usr/man/man8:/usr/share/man/man8:' \
	    -i Makefile

	sed -e 's/^CFLAGS =/CFLAGS +=/' \
	    -e 's/^CC =/CC ?=/' \
	    -e 's/$(CC) $(CFLAGS)/$(CC) $(LDFLAGS) $(CFLAGS)/' \
	    -i src/Makefile
}

src_compile() {
	tc-export CC
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHOR CHANGELOG CONFIG README SECURITY TODO

	use gtk || rm "${D}/usr/bin/sobexsrv_handler"

	newinitd "${FILESDIR}/init.d_sobexsrv" sobexsrv
	newconfd "${FILESDIR}/conf.d_sobexsrv" sobexsrv

	keepdir /var/spool/sobexsrv
	fowners sobexsrv:sobexsrv /var/spool/sobexsrv
}

pkg_postinst() {
	elog
	elog "/usr/bin/sobexsrv is *NOT* installed set-uid root by"
	elog "default. suid is required for the chroot option (-R)."
	elog
	elog "Execute the following commands to enable suid:"
	elog
	elog "chown root:sobexsrv /usr/bin/sobexsrv"
	elog "chmod 4710 /usr/bin/sobexsrv"
	elog
}
