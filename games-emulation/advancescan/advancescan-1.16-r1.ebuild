# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils

DESCRIPTION="A command line rom manager for MAME, MESS, AdvanceMAME, AdvanceMESS and Raine"
HOMEPAGE="http://advancemame.sourceforge.net/scan-readme.html"
SRC_URI="mirror://sourceforge/advancemame/${P}.tar.gz
	https://dev.gentoo.org/~juippis/distfiles/tmp/advancescan-1.16-gcc6.patch"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/expat
	sys-libs/zlib"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-sys-expat.patch
	"${DISTDIR}"/${P}-gcc6.patch
)

src_prepare() {
	rm -rf expat
	default
	eautoreconf
}

src_install() {
	dobin advscan advdiff
	dodoc AUTHORS HISTORY README doc/*.txt advscan.rc.linux
	doman doc/{advscan,advdiff}.1
	dohtml doc/*.html
}
