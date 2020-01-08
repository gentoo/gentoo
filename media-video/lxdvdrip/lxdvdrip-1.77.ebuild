# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Command line tool to automate the process of ripping and burning DVDs"
SRC_URI="mirror://sourceforge/lxdvdrip/${P}.tgz"
HOMEPAGE="https://sourceforge.net/projects/lxdvdrip/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="media-libs/libdvdread"
RDEPEND="${DEPEND}
	>=media-video/dvdauthor-0.6.9
	media-video/streamdvd
	media-video/mpgtx"

S="${WORKDIR}/${PN}"

src_prepare() {
	epatch "${FILESDIR}/${P}-makefile.patch"
	epatch "${FILESDIR}/${P}-vamps-makefile.patch"
}

src_compile() {
	CC="$(tc-getCC)" emake
	cd "${S}/vamps"
	emake CC="$(tc-getCC)"
}

src_install () {
	dobin lxdvdrip
	dobin lxac3scan
	dodoc doc-pak/Changelog* doc-pak/Credits doc-pak/Debugging.*
	dodoc doc-pak/lxdvdrip.conf* doc-pak/README*
	doman lxdvdrip.1

	insinto /usr/share
	doins lxdvdrip.wav

	insinto /etc
	newins doc-pak/lxdvdrip.conf.EN lxdvdrip.conf

	cd "${S}/vamps"
	emake PREFIX="${D}/usr" install
}
