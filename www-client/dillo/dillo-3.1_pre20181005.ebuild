# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools desktop toolchain-funcs

DESCRIPTION="Lean FLTK based web browser"
HOMEPAGE="https://www.dillo.org/"
SRC_URI="
	https://dev.gentoo.org/~jsmolic/distfiles/${P}.tar.xz
	mirror://gentoo/${PN}.png
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv sparc x86"
IUSE="doc +gif ipv6 +jpeg +png ssl +xembed"

RDEPEND="
	>=x11-libs/fltk-1.3
	sys-libs/zlib
	jpeg? ( virtual/jpeg:0 )
	png? ( >=media-libs/libpng-1.2:0 )
	ssl? ( net-libs/mbedtls:= )
"
DEPEND="
	${RDEPEND}
	doc? ( app-doc/doxygen )
"
PATCHES=(
	"${FILESDIR}"/${PN}2-inbuf.patch
	"${FILESDIR}"/${PN}-3.0.5-fno-common.patch
	"${FILESDIR}"/${PN}-3.0.5-disable-ssl.patch
)
DOCS="AUTHORS ChangeLog README NEWS doc/*.txt doc/README"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf  \
		$(use_enable gif) \
		$(use_enable ipv6) \
		$(use_enable jpeg) \
		$(use_enable png) \
		$(use_enable ssl) \
		$(use_enable xembed)
}

src_compile() {
	emake AR="$(tc-getAR)"
	if use doc; then
		doxygen Doxyfile || die
	fi
}

src_install() {
	default

	use doc && dodoc -r html

	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} Dillo
}
