# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils

DESCRIPTION="IBM AS/400 telnet client which emulates 5250 terminals/printers"
HOMEPAGE="http://tn5250.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="X libressl ssl"

RDEPEND="
	sys-libs/ncurses:=
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
"

DEPEND="${RDEPEND}
	X? ( x11-libs/libXt )
"

PATCHES=(
	"${FILESDIR}/disable-sslv2-and-sslv3.patch"
	"${FILESDIR}/fix-Wformat-security-warnings.patch"
)

src_prepare() {
	default

	# Next, the Makefile for the terminfo settings tries to remove
	# some files it doesn't have access to.	 We can just remove those
	# lines.
	sed -i \
		-e "/rm -f \/usr\/.*\/terminfo.*5250/d" linux/Makefile.in \
		|| die "sed Makefile.in failed"
}

src_configure() {
	econf \
		--disable-static \
		--without-python \
		$(use_with X x) \
		$(use_with ssl)
}

src_install() {
	# The TERMINFO variable needs to be defined for the install
	# to work, because the install calls "tic."	 man tic for
	# details.
	dodir /usr/share/terminfo
	emake DESTDIR="${D}" TERMINFO="${D}/usr/share/terminfo" install

	einstalldocs
	prune_libtool_files
}
