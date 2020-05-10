# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="Network discovery and fingerprinting tool"
HOMEPAGE="http://www.thc.org/thc-rut/"
SRC_URI="http://www.thc.org/thc-rut/${P}.tar.gz"

LICENSE="free-noncomm PCRE GPL-1+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

DEPEND="
	dev-libs/libpcre
	net-libs/libnet:1.0
	net-libs/libpcap
"
RDEPEND="
	${DEPEND}
"
DOCS=( ChangeLog FAQ README TODO thcrutlogo.txt )
PATCHES=(
	"${FILESDIR}"/${P}-configure.patch
	"${FILESDIR}"/${P}-flags.patch
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-libnet.patch
)

src_prepare() {
	rm -r Libnet-1.0.2a pcre-3.9 || die
	default
	eautoreconf
}
