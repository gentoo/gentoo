# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools flag-o-matic

DESCRIPTION="GNU/Linux port of the MAME emulator with GUI menu"
HOMEPAGE="http://www.advancemame.it/"
SRC_URI="https://github.com/amadvance/advancemame/releases/download/v${PV}/${P}.tar.gz"

# Fetch too big upstream patch
SRC_URI+=" https://github.com/amadvance/advancemame/commit/70f099ac49786a287ebd3949ce8f8670a5731abd.patch -> ${PN}-3.7-use_pkgconfig_for_freetype_and_sdl.patch"

LICENSE="GPL-2 XMAME"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa fbcon oss truetype"

# sdl is required (bug #158417)
RDEPEND="
	app-arch/unzip
	app-arch/zip
	dev-libs/expat
	media-libs/libsdl2
	sys-libs/zlib
	alsa? ( media-libs/alsa-lib )
	truetype? ( media-libs/freetype:2 )
"
DEPEND="${RDEPEND}
	virtual/os-headers
	virtual/pkgconfig
	x86? ( >=dev-lang/nasm-0.98 )
"

PATCHES=(
	"${FILESDIR}/${PN}-1.2-pic.patch"
	"${FILESDIR}"/${PN}-1.2-verboselog.patch

	# Patches from upstream
	"${FILESDIR}/${P}-move_aclocal_to_acinclude.patch"
	"${DISTDIR}/${P}-use_pkgconfig_for_freetype_and_sdl.patch"
	"${FILESDIR}/${P}-remove_static_configure_option.patch"
)

src_prepare() {
	default
	eautoreconf

	sed -i -e 's/"-s"//' configure || die

	use x86 && ln -s $(type -P nasm) "${T}/${CHOST}-nasm"
	ln -s $(type -P sdl2-config) "${T}/${CHOST}-sdl2-config"
}

src_configure() {
	# Fix for bug #78030
	if use ppc; then
		append-ldflags "-Wl,--relax"
	fi

	PATH="${PATH}:${T}"
	econf \
		--enable-expat \
		--enable-sdl2 \
		--disable-sdl \
		--enable-zlib \
		--disable-slang \
		--disable-svgalib \
		$(use_enable alsa) \
		$(use_enable fbcon fb) \
		$(use_enable oss) \
		$(use_enable truetype freetype) \
		$(use_enable x86 asm)
}

src_compile() {
	STRIPPROG=true emake
}

src_install() {
	local f

	for f in adv* ; do
		if [[ -L "${f}" ]] ; then
			dobin "${f}"
		fi
	done

	insinto "/usr/share/advance"
	doins support/event.dat
	keepdir "/usr/share/advance/"{artwork,diff,image,rom,sample,snap}

	dodoc HISTORY README RELEASE
	cd doc
	dodoc *.txt
	HTMLDOCS="*.html" einstalldocs

	for f in *.1 ; do
		newman ${f} ${f/1/6}
	done
}
