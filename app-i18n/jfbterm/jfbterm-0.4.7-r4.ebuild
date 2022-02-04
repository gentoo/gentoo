# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools flag-o-matic

DESCRIPTION="The J Framebuffer Terminal/Multilingual Enhancement with UTF-8 support"
HOMEPAGE="http://jfbterm.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/${PN}/13501/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE="debug"

DEPEND="sys-libs/ncurses:0"
RDEPEND="media-fonts/font-misc-misc
	media-fonts/intlfonts
	media-fonts/unifont"

PATCHES=(
	"${FILESDIR}"/${PN}-sigchld-debian.patch
	"${FILESDIR}"/${PN}-no-kernel-headers.patch
	"${FILESDIR}"/${PN}-gentoo.patch
	"${FILESDIR}"/${PN}-wrong-inline-gcc5.patch
	"${FILESDIR}"/${PN}-automake-1.13.patch
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf $(use_enable debug)
}

src_install() {
	dodir /etc /usr/share/fonts/${PN}
	default

	mv "${ED}"/etc/${PN}.conf{.sample,} || die

	doman ${PN}.{1,conf.5}

	# install example config files
	docinto examples
	dodoc ${PN}.conf.sample*
	docompress -x /usr/share/doc/${PF}/examples
}
