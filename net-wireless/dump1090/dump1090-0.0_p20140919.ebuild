# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs eutils

DESCRIPTION="simple Mode S decoder for RTLSDR devices"
HOMEPAGE="https://github.com/antirez/dump1090"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/antirez/dump1090.git"
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://dev.gentoo.org/~zerochaos/distfiles/${P}.tar.xz"
	S="${WORKDIR}/${PN}"
fi

LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="net-wireless/rtl-sdr"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/gmap_usr_share_mv.patch
}

src_compile() {
	emake CC="$(tc-getCC)" \
		CFLAGS="$(pkg-config --cflags librtlsdr)" \
		LIBS="${LDFLAGS} $(pkg-config --libs librtlsdr) -lm -lpthread" \
		all
}

src_install() {
	dobin ${PN}
	dodoc TODO README.md

	insinto /usr/share/${PN}
	doins gmap.html
	doins tools/debug.html
}
