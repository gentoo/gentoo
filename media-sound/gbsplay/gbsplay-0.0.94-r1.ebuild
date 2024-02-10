# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PLOCALES="de en"
inherit edo plocale toolchain-funcs

DESCRIPTION="Nintendo Gameboy sound player for GBS format"
HOMEPAGE="https://www.cgarbs.de/gbsplay.en.html"
SRC_URI="https://github.com/mmitch/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+alsa nas nls oss pulseaudio"

RDEPEND="
	alsa? ( media-libs/alsa-lib:0 )
	nas? ( media-libs/nas:0 )
	pulseaudio? ( media-libs/libpulse )
"
DEPEND="${RDEPEND}"
BDEPEND="nls? ( sys-devel/gettext:0 )"

PATCHES=(
	# git master
	"${FILESDIR}/${P}-fix-sharedlib-build.patch"
	"${FILESDIR}/${P}-fix-off-by-one-err.patch"
	"${FILESDIR}/${P}-fix-buildsys-1.patch"
	"${FILESDIR}/${P}-fix-buildsys-2.patch"
	# downstream
	"${FILESDIR}/${P}-no-install-desktop-mime.patch"
)

src_prepare() {
	default

	# Don't clobber toolchain defaults
	sed -i -e 's:-D_FORTIFY_SOURCE=2::' configure || die
}

src_configure() {
	tc-export AR CC

	local myconfargs=(
		--prefix=/usr
		--mandir=/usr/share/man
		--docdir=/usr/share/doc/${PF}
		--disable-hardening
		--without-xmmsplugin
		--without-test
		$(use_enable alsa)
		$(use_enable nas)
		$(use_enable nls i18n)
		$(use_enable oss devdsp)
		$(use_enable pulseaudio pulse)
	)

	# No econf, because "unknown option '--libdir=/usr/lib64"
	edo ./configure "${myconfargs[@]}"
}

src_compile() {
	emake CC="$(tc-getCC)" SPLINT="true" V=1
}

src_install() {
	remove_disabled_locale() {
		rm -r "${D}"/usr/share/locale/$1 || die
	}
	default

	plocale_for_each_disabled_locale remove_disabled_locale
}
