# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop

DESCRIPTION="Digger Remastered"
HOMEPAGE="https://www.digger.org/"
SRC_URI="
	mirror://gentoo/${P}.tar.gz
	https://dev.gentoo.org/~ionen/distfiles/${PN}.png"
S="${WORKDIR}/${PN}-${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

RDEPEND="
	media-libs/libsdl[X,sound,video]
	sys-libs/zlib:=
	x11-libs/libX11"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"

src_install() {
	dobin "${BUILD_DIR}"/${PN}
	dodoc ${PN}.txt

	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} ${PN^}
}
