# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools flag-o-matic

DESCRIPTION="GNU/Linux port of the MAME emulator with GUI menu"
HOMEPAGE="http://www.advancemame.it/"
SRC_URI="https://github.com/amadvance/advancemame/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2 XMAME"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa fbcon ncurses oss slang truetype"

# sdl is required (bug #158417)
DEPEND="
	dev-libs/expat
	media-libs/libsdl2[video]
	sys-libs/zlib
	alsa? ( media-libs/alsa-lib )
	ncurses? ( sys-libs/ncurses:= )
	slang? ( sys-libs/slang )
	truetype? ( media-libs/freetype:2 )
"
RDEPEND="
	${DEPEND}
	app-arch/unzip
	app-arch/zip
"
BDEPEND="
	virtual/pkgconfig
	x86? ( >=dev-lang/nasm-0.98 )
"

PATCHES=(
	"${FILESDIR}"/${PN}-pic.patch
	"${FILESDIR}"/${PN}-verboselog.patch

	# Patches from upstream
	"${FILESDIR}"/${P}-pkgconfig_for_ncurses_and_slang.patch
)

src_prepare() {
	default

	# AC_CHECK_CC_OPT is obsolete, superseded by AX_CHECK_COMPILE_FLAG
	sed -i -e 's/AC_CHECK_CC_OPT/AX_CHECK_COMPILE_FLAG/' configure.ac || die

	eautoreconf
	sed -i -e 's/"-s"//' configure || die

	use x86 && ln -s $(type -P nasm) "${T}/${CHOST}-nasm"
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
		$(use_enable ncurses) \
		$(use_enable oss) \
		$(use_enable slang) \
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
