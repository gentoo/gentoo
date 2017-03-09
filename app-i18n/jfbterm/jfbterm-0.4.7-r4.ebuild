# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic

DESCRIPTION="The J Framebuffer Terminal/Multilingual Enhancement with UTF-8 support"
HOMEPAGE="http://jfbterm.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/${PN}/13501/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE="debug"

DEPEND="sys-libs/ncurses:0"
RDEPEND="
	media-fonts/unifont
	media-fonts/font-misc-misc
	media-fonts/intlfonts"

PATCHES=(
	"${FILESDIR}"/${P}-sigchld-debian.patch
	"${FILESDIR}"/${P}-no-kernel-headers.patch
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-wrong-inline-gcc5.patch
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
	dodir /etc /usr/share/fonts/jfbterm
	default

	mv "${ED%/}"/etc/jfbterm.conf{.sample,} || die

	doman jfbterm.1 jfbterm.conf.5

	# install example config files
	docinto examples
	dodoc jfbterm.conf.sample*
	docompress -x /usr/share/doc/${PF}/examples
}
