# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop flag-o-matic

DESCRIPTION="A simple GTK/command line TCP/IP packet generator"
HOMEPAGE="http://gspoof.sourceforge.net/"
SRC_URI="http://gspoof.sourceforge.net/src/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

DEPEND="
	x11-libs/gtk+:2
	dev-libs/glib:2
	net-libs/libnet:1.1
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-def-values.patch"
	"${FILESDIR}/${PN}-3.2-icon.patch"
	"${FILESDIR}/${PN}-3.2-libdir.patch"
	"${FILESDIR}/${PN}-3.2-fno-common.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/861158
	#
	# Upstream sourceforge is dead. Software last updated in December 2003.
	# No bug filed.
	filter-lto

	default
}

src_compile() {
	emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin gspoof
	newicon pixmap/icon.png ${PN}.png
	dodoc README CHANGELOG TODO
}
