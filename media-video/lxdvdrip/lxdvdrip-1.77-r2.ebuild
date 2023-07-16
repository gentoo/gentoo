# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Command line tool to automate the process of ripping and burning DVDs"
HOMEPAGE="https://sourceforge.net/projects/lxdvdrip/"
SRC_URI="mirror://sourceforge/lxdvdrip/${P}.tgz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="media-libs/libdvdread"
RDEPEND="${DEPEND}
	>=media-video/dvdauthor-0.6.9
	media-video/streamdvd
	media-video/mpgtx
"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-vamps-makefile.patch
	"${FILESDIR}"/${P}-clang-16-build.patch
)

src_compile() {
	tc-export CC
	emake
	emake -C vamps
}

src_install() {
	dobin lxdvdrip
	dobin lxac3scan
	dodoc doc-pak/Changelog* doc-pak/Credits doc-pak/Debugging.*
	dodoc doc-pak/lxdvdrip.conf* doc-pak/README*
	doman lxdvdrip.1

	insinto /usr/share
	doins lxdvdrip.wav

	insinto /etc
	newins doc-pak/lxdvdrip.conf.EN lxdvdrip.conf

	cd vamps || die
	emake PREFIX="${D}/usr" install
}
