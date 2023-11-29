# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="Analogue clock utility for X Windows"
HOMEPAGE="https://tigr.net/afterstep/applets/ http://www.afterstep.org/"
SRC_URI="http://www.tigr.net/afterstep/download/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE="jpeg"

RDEPEND="
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm
	jpeg? ( media-libs/libjpeg-turbo:= )
"

DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"

PATCHES=(
	"${FILESDIR}/${P}-respect-ldflags.patch"
	"${FILESDIR}/${P}-remove-double-config.h-autotools.patch"
	"${FILESDIR}/${P}-fix-implicit-function-decl.patch"
)

src_prepare() {
	default
	cd "${S}/autoconf" || die
	eautoreconf
	cp "${S}/autoconf/configure" "${S}/" || die
}

src_configure() {
	econf $(use_enable jpeg) --with-xpm-library=/usr/$(get_libdir)
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin "${PN}"
	newman "${PN}.man" "${PN}.1"
	einstalldocs
}
