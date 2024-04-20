# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

MY_P="${PN}-QPL-${PV}"

DESCRIPTION="Xlib base 2-D drawing facility under X11"
HOMEPAGE="http://bourbon.usc.edu/tgif/index.html"
SRC_URI="ftp://bourbon.usc.edu/pub/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="QPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

DEPEND="
	sys-libs/zlib
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXt
"
RDEPEND="
	${DEPEND}
	media-libs/netpbm
"

PATCHES=(
	"${FILESDIR}/${P}-wformat-security.patch"
	"${FILESDIR}/${P}-implicit-int.patch"
)

src_prepare() {
	default

	sed -i \
		-e 's/^CFLAGS=/CFLAGS+=/' \
		-e 's:^TGIFDIR.*:TGIFDIR = $(datadir)/tgif:' \
		Makefile.am || die 'sed on Makefile.am failed'

	eautoreconf
}

src_configure() {
	# bug #881325
	append-cflags -std=gnu89
	append-cppflags -D_DONT_USE_MKTEMP -DHAS_STREAMS_SUPPORT

	default
}
