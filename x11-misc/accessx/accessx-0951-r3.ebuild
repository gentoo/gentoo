# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Interface to the XKEYBOARD extension in X11"
HOMEPAGE="http://cita.disability.uiuc.edu/software/accessx/freewareaccessx.php"
SRC_URI="http://cmos-eng.rehab.uiuc.edu/${PN}/software/${PN}${PV}.tar.gz"
S="${WORKDIR}"/${PN}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc sparc x86"

RDEPEND="
	dev-lang/tk:=
	x11-libs/libX11
	x11-libs/libXext
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
)

src_prepare() {
	default

	sed -i \
		-e 's:$(CC) $(OPTS) ax.C:$(CC) $(LDFLAGS) $(OPTS) ax.C:' \
		Makefile || die
}

src_compile() {
	emake \
		CC="$(tc-getCXX)" \
		OPTS="${CXXFLAGS}" \
		XLIBDIR="-L${ESYSROOT}/usr/$(get_libdir)" \
		LLIBS="$($(tc-getPKG_CONFIG) --libs xext) $($(tc-getPKG_CONFIG) --libs x11)"
}

src_install() {
	dobin accessx ax
	einstalldocs
}
