# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_P=${P/.0/}
DESCRIPTION="Linux support for Easy Access and Internet Keyboards"
HOMEPAGE="https://lineak.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/lineak/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="debug"

RDEPEND="x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	x11-libs/libxkbfile
	x11-libs/libXt
	x11-libs/libXtst"

PATCHES=(
	"${FILESDIR}"/${P}-gcc43.patch
	"${FILESDIR}"/${P}-DELL-XPS-M1330-XOrg-1_5.patch
	"${FILESDIR}"/${P}-automake-linking-libdl.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	# admin/lineakd.m4.in contains Bashisms but fixes it causes a confusing
	# autotools avalanche, so workaround it with CONFIG_SHELL as bash.
	CONFIG_SHELL="${BROOT}/bin/bash" econf \
		$(use_enable debug) \
		--with-x
}

src_install() {
	sed -i -e 's:$(DESTDIR)${DESTDIR}:$(DESTDIR):' lineakd/Makefile || die

	dodir /usr/share/man/man8

	emake -j1 DESTDIR="${D}" install

	dodoc AUTHORS README TODO

	keepdir /usr/$(get_libdir)/lineakd/plugins

	insinto /etc/lineak
	doins lineakd.conf.example lineakd.conf.kde.example

	find "${ED}"/usr/share/man -name '*.bz2' -exec bunzip2 {} \; || die
	find "${ED}" -name '*.la' -delete || die
}
