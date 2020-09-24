# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P="${P/_pre/pre}"

DESCRIPTION="Scripting/Secure OBEX Server (for BlueZ Linux)"
SRC_URI="http://www.mulliner.org/bluetooth/${MY_P}.tar.gz
		 https://dev.gentoo.org/~joker/${P}-fix64.patch"
HOMEPAGE="http://www.mulliner.org/bluetooth/sobexsrv.php"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"

DEPEND="
	>=dev-libs/openobex-1.7.2-r1
	net-wireless/bluez
"
RDEPEND="${DEPEND}
	acct-user/sobexsrv
	acct-group/sobexsrv
"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${DISTDIR}/${P}"-fix64.patch
	"${FILESDIR}/${P}"-openobex16.patch
)

src_prepare() {
	default

	sed -e 's:/usr/man/man8:/usr/share/man/man8:' \
		-e 's/install: all/install:/' \
	    -i Makefile || die

	sed -e 's/^CFLAGS =/CFLAGS +=/' \
	    -e 's/^CC =/CC ?=/' \
	    -e 's/$(CC) $(CFLAGS)/$(CC) $(LDFLAGS) $(CFLAGS)/' \
	    -i src/Makefile || die
}

src_compile() {
	tc-export CC
	emake -C src
}

src_install() {
	default
	dodoc AUTHOR CONFIG SECURITY THANKS
	rm "${D}/usr/bin/sobexsrv_handler" || die

	newinitd "${FILESDIR}/init.d_sobexsrv" sobexsrv
	newconfd "${FILESDIR}/conf.d_sobexsrv" sobexsrv
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
