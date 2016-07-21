# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 toolchain-funcs user

MY_P="${P/_pre/pre}"

DESCRIPTION="Scripting/Secure OBEX Server (for BlueZ Linux)"
SRC_URI="http://www.mulliner.org/bluetooth/${MY_P}.tar.gz
		 https://dev.gentoo.org/~joker/${P}-fix64.patch"
HOMEPAGE="http://www.mulliner.org/bluetooth/sobexsrv.php"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="gtk"

DEPEND="
	dev-libs/openobex
	net-wireless/bluez
	gtk? ( ${PYTHON_DEPS} )"
RDEPEND="${DEPEND}
	gtk? (
		${PYTHON_DEPS}
		>=dev-python/pygtk-2.2
	)"
REQUIRED_USE="
	gtk? ( ${PYTHON_REQUIRED_USE} )"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${DISTDIR}/${P}"-fix64.patch
	"${FILESDIR}/${P}"-openobex16.patch
)

pkg_setup() {
	use gtk && python-single-r1_pkg_setup

	enewgroup sobexsrv
	enewuser sobexsrv -1 -1 /var/spool/sobexsrv sobexsrv
}

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

	if use gtk; then
		python_doscript "${D}/usr/bin/sobexsrv_handler"
		newdoc "${S}/scripts/test" sobexsrv_handler.sample_script
	else
		rm "${D}/usr/bin/sobexsrv_handler" || die
	fi

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
