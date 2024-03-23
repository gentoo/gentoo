# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Network performance measurement tool"
HOMEPAGE="http://flowgrind.net/ https://github.com/flowgrind/flowgrind/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${P}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc gsl pcap"

RDEPEND="dev-libs/xmlrpc-c:=[abyss,curl]
	sys-apps/util-linux
	gsl? ( sci-libs/gsl:= )
	pcap? ( net-libs/libpcap )"
DEPEND="${RDEPEND}"
BDEPEND="doc? ( app-text/doxygen )"

src_configure() {
	econf \
		--disable-debug \
		$(use_with doc doxygen) \
		$(use_with gsl) \
		$(use_with pcap)
}

src_compile() {
	default

	use doc && emake html
}

src_install() {
	default

	use doc && dodoc -r doc/html
}
