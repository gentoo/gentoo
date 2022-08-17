# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="WindowMaker CPU and Memory Usage Monitor Dock App"
HOMEPAGE="https://www.geocities.ws/neofpo/wmcms.html"
SRC_URI="https://www.geocities.ws/neofpo/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

DEPEND=">=x11-libs/libdockapp-0.7:="

PATCHES=(
	"${FILESDIR}"/${P}-s4t4n.patch
)

src_prepare() {
	default

	# Respect LDFLAGS, see bug #335031
	sed -e 's/ -o wmcms/ ${LDFLAGS} -o wmcms/' -i Makefile || die

	sed -e 's#<dockapp.h>#<libdockapp/dockapp.h>#' -i *.c || die
}

src_compile() {
	emake CFLAGS="${CFLAGS}" CC="$(tc-getCC)"
}

src_install() {
	dobin wmcms
}
