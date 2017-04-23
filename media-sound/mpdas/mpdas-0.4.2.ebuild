# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit toolchain-funcs

DESCRIPTION="An AudioScrobbler client for MPD written in C++"
HOMEPAGE="http://50hz.ws/mpdas/"
SRC_URI="http://50hz.ws/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/libmpdclient
	net-misc/curl"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	sed -i -e 's/@//' Makefile || die
	default
}

src_compile() {
	tc-export CXX
	emake CONFIG="/etc"
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	newinitd "${FILESDIR}/${PN}.init" ${PN}
	dodoc mpdasrc.example README
}

pkg_postinst() {
	elog "For further configuration help consult the README in"
	elog "${EPREFIX}/usr/share/doc/${PF}"
}
