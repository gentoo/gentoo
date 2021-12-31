# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit eutils

DESCRIPTION="rxvt compatible terminal emulator with transparency and tab support"
HOMEPAGE="http://www.nongnu.org/materm/materm.html"
SRC_URI="http://www.nongnu.org/materm/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ~mips ppc sparc x86"
IUSE="cjk debug jpeg png"

RDEPEND="x11-libs/libXpm
	jpeg? ( virtual/jpeg )
	png? ( media-libs/libpng )"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

DOCS=( AUTHORS ChangeLog NEWS TODO )

src_prepare() {
	epatch "${FILESDIR}"/${PV}-initialize-vars.patch \
		"${FILESDIR}"/${P}-display-security-issue.patch \
		"${FILESDIR}"/${P}-libpng14.patch

	sed -i \
		-e 's:png_check_sig:png_sig_cmp:' \
		configure || die
}

src_configure() {
	econf \
		--enable-transparency \
		--enable-fading \
		--enable-xterm-scroll \
		--enable-half-shadow \
		--enable-graphics \
		--enable-mousewheel \
		--with-x \
		--with-xpm=/usr \
		$(use_enable cjk kanji) \
		$(use_enable debug) \
		$(use_enable jpeg) \
		$(use_enable png)
}

src_compile() {
	emake CFLAGS="${CFLAGS}"
}

src_install() {
	default
	newdoc doc/TODO TODO.2
}
