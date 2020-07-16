# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="AudioScrobbler client for MPD written in C++"
HOMEPAGE="https://50hz.ws/mpdas/"
SRC_URI="https://50hz.ws/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	media-libs/libmpdclient
	net-misc/curl"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -i -e 's/@//' Makefile || die
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
