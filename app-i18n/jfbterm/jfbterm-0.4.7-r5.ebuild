# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools font

DESCRIPTION="The J Framebuffer Terminal/Multilingual Enhancement with UTF-8 support"
HOMEPAGE="https://osdn.net/projects/jfbterm/"
SRC_URI="mirror://sourceforge.jp/${PN}/13501/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE="debug"

# ncurses is runtime-onlu dependency, because program provides it's own terminfo
# gzip needed for unpacking font at runtime
RDEPEND="
	media-fonts/font-misc-misc
	media-fonts/intlfonts
	media-fonts/unifont
	sys-libs/ncurses
	app-alternatives/gzip
"

PATCHES=(
	"${FILESDIR}"/${PN}-sigchld-debian.patch
	"${FILESDIR}"/${PN}-no-kernel-headers.patch
	"${FILESDIR}"/${PN}-gentoo.patch
	"${FILESDIR}"/${PN}-wrong-inline-gcc5.patch
	"${FILESDIR}"/${PN}-automake-1.13.patch
	"${FILESDIR}"/"${P}"-fonts.patch
	"${FILESDIR}"/"${P}"-gettimeoftheday.patch
)

FONT_S="${S}/fonts"
FONT_SUFFIX="pcf.gz"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf $(use_enable debug)
}

src_install() {
	dodir /etc
	default

	mv "${ED}"/etc/${PN}.conf{.sample,} || die

	font_src_install

	doman ${PN}.{1,conf.5}

	# install example config files
	docinto examples
	dodoc ${PN}.conf.sample*
	docompress -x /usr/share/doc/${PF}/examples
}
