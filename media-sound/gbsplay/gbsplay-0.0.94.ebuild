# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PLOCALES="de en"
inherit plocale toolchain-funcs

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
	./configure ${myconfargs[@]} || die "Configure failed."
}

src_compile() {
	emake CC="$(tc-getCC)" SPLINT="true"
}

src_install() {
	remove_disabled_locale() {
		rm -r "${D}"/usr/share/locale/$1 || die
	}
	default

	plocale_for_each_disabled_locale remove_disabled_locale
}
