# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PLOCALES="de en"
inherit l10n toolchain-funcs

DESCRIPTION="Nintendo Gameboy sound player for GBS format"
HOMEPAGE="https://www.cgarbs.de/gbsplay.en.html"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+alsa nas nls oss"

RDEPEND="alsa? ( media-libs/alsa-lib:0 )
	nas? ( media-libs/nas:0 )"

DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext:0 )"

PATCHES=(
	"${FILESDIR}/${P}-fix-buildsystem.patch"
)

src_configure() {
	tc-export AR CC

	# No econf, because "unknown option '--build=x86_64-pc-linux-gnu'"
	./configure \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--docdir=/usr/share/doc/${PF} \
		--without-xmmsplugin \
		--without-test \
		$(use_enable nls i18n) \
		$(use_enable oss devdsp) \
		$(use_enable alsa) \
		$(use_enable nas) || die "Configure failed."
}

src_compile() {
	emake CC="$(tc-getCC)" SPLINT="true"
}

remove_disabled_locale() {
	rm -r "${D}"/usr/share/locale/$1 || die
}

src_install() {
	default

	l10n_for_each_disabled_locale_do remove_disabled_locale
}
