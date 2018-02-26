# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs versionator

MY_PV=${PV/_rc/pr}
DESCRIPTION="Notebook battery indicator for X"
HOMEPAGE="http://www.clave.gr.jp/~eto/xbatt/"
SRC_URI="http://www.clave.gr.jp/~eto/xbatt/${PN}-${MY_PV}.tar.gz"

LICENSE="xbatt"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
RDEPEND="
	x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libXaw
	x11-libs/libXext
	x11-libs/libxkbfile
	x11-libs/libXpm
"
DEPEND="
	${RDEPEND}
	x11-proto/xextproto
	x11-misc/imake
"
PATCHES=(
	"${FILESDIR}"/${PN}-1.2.1-implicits.patch
)
S="${WORKDIR}"/${PN}-$(get_version_component_range 1-2)

src_compile() {
	xmkmf || die
	emake \
		CC="$(tc-getCC)" \
		CDEBUGFLAGS="${CFLAGS}" \
		EXTRA_LDOPTIONS="${LDFLAGS}" \
		xbatt
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README*
}
