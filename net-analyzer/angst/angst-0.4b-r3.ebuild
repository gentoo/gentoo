# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit flag-o-matic toolchain-funcs

DESCRIPTION="an active sniffer that provides methods for aggressive sniffing on switched LANs"
HOMEPAGE="http://angst.sourceforge.net/"
SRC_URI="http://angst.sourceforge.net/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug"

DEPEND="
	net-libs/libpcap
	net-libs/libnet:1.0
"
RDEPEND="
	${DEPEND}
"
PATCHES=(
	"${FILESDIR}"/${PV}-flags.patch
	"${FILESDIR}"/${PV}-libnet-1.0.patch
	"${FILESDIR}"/${PV}-sysctl.h.patch
)

src_configure() {
	append-cflags -fcommon
	use debug && append-cppflags -DDEBUG
}

src_compile() {
	emake \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		CC="$(tc-getCC)" \
		-f Makefile.linux
}

src_install() {
	dosbin angst
	doman angst.8
	dodoc README TODO ChangeLog
}
