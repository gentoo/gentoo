# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A command line rom manager for MAME, MESS, AdvanceMAME, AdvanceMESS and Raine"
HOMEPAGE="http://advancemame.sourceforge.net/scan-readme.html"
SRC_URI="
	mirror://sourceforge/advancemame/${P}.tar.gz
	https://dev.gentoo.org/~juippis/distfiles/tmp/advancescan-1.16-gcc6.patch"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-libs/expat
	sys-libs/zlib"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-sys-expat.patch
	"${DISTDIR}"/${P}-gcc6.patch
	"${FILESDIR}"/${P}-gcc11.patch
)

src_prepare() {
	rm -rf expat || die
	default
	eautoreconf
}

src_install() {
	dobin advscan advdiff
	dodoc AUTHORS HISTORY README doc/*.txt advscan.rc.linux
	doman doc/{advscan,advdiff}.1

	docinto html
	dodoc doc/*.html
}
