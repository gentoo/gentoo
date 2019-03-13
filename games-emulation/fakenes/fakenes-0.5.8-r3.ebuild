# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop flag-o-matic toolchain-funcs gnome2-utils

DESCRIPTION="Portable, Open Source NES emulator which is written mostly in C"
HOMEPAGE="http://fakenes.sourceforge.net/"
SRC_URI="mirror://sourceforge/fakenes/${P}.tar.bz2"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="openal opengl zlib"

RDEPEND="
	>=media-libs/allegro-4.4.1.1:0[opengl?]
	dev-games/hawknl
	openal? (
		media-libs/openal
		media-libs/freealut
	)
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	default
	sed -i \
		-e "s:openal-config:pkg-config openal:" \
		build/openal.cbd || die

	sed -i \
		-e "s:LIBAGL = agl:LIBAGL = alleggl:" \
		build/alleggl.cbd || die
	eapply "${FILESDIR}"/${P}-{underlink,zlib}.patch
}

src_compile() {
	local myconf

	append-ldflags -Wl,-z,noexecstack

	echo "$(tc-getBUILD_CC) cbuild.c -o cbuild"
	$(tc-getBUILD_CC) cbuild.c -o cbuild || die "cbuild build failed"

	use openal || myconf="$myconf -openal"
	use opengl || myconf="$myconf -alleggl"
	use zlib   || myconf="$myconf -zlib"

	LD="$(tc-getCC) ${CFLAGS}" ./cbuild ${myconf} --verbose || die "cbuild failed"
}

src_install() {
	dobin fakenes
	insinto "/usr/share/${PN}"
	doins support/*

	cd docs && HTML_DOCS="faq.html" einstalldocs && cd ..

	newicon -s 32 support/icon-32x32.png ${PN}.png
	make_desktop_entry ${PN} "FakeNES"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
