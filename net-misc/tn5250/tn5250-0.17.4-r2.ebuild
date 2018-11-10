# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools ltprune

DESCRIPTION="IBM AS/400 telnet client which emulates 5250 terminals/printers"
HOMEPAGE="http://tn5250.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="libressl ssl static-libs"

RDEPEND="
	sys-libs/ncurses:=
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
"

DEPEND="
	${RDEPEND}
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.17.4-disable-sslv2-and-sslv3.patch
	"${FILESDIR}"/${PN}-0.17.4-fix-Wformat-security-warnings.patch
	"${FILESDIR}"/${PN}-0.17.4-tinfo.patch
	"${FILESDIR}"/${PN}-0.17.4-whoami.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_with ssl) \
		--without-python
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
