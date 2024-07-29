# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools
DESCRIPTION="General Stream I/O"
HOMEPAGE="https://sourceforge.net/projects/ser2net"
SRC_URI="https://downloads.sourceforge.net/ser2net/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug tcpd"

DEPEND="
	tcpd? ( sys-apps/tcp-wrappers )
"
RDEPEND="${DEPEND}"

# Test suite requires a kernel module
RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${PN}-2.8.5-install-dir.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--with-file-stdio \
		--without-link-ssl-with-main \
		--with-uucp-locking \
		--with-flock-locking \
		--without-broken-pselect \
		--with-pthreads \
		--without-glib \
		--without-cplusplus \
		--without-python \
		--without-go \
		--without-swig \
		--without-all-gensios \
		--without-moduleinstall \
		--with-net=yes \
		--with-udp=yes \
		--with-sctp=no \
		--with-stdio=yes \
		--with-pty=yes \
		--with-serialdev=yes \
		--with-telnet=yes \
		--without-tcl \
		--without-openipmi \
		--without-ipmisol \
		--without-mdns \
		--without-dnssd \
		--without-alsa \
		--without-winsound \
		--without-portaudio \
		--without-certauth \
		--without-udev \
		--without-ssl \
		--enable-doc \
		--disable-internal-trace \
		$(use_with tcpd tcp-wrappers) \
		$(use_enable debug)
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
