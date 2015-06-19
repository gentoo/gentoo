# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/gbsplay/gbsplay-0.0.91-r1.ebuild,v 1.3 2015/04/02 18:26:50 mr_bones_ Exp $

EAPI="5"

IUSE="+alsa nas nls oss"
PLOCALES="de en"

inherit l10n toolchain-funcs

DESCRIPTION="Nintendo Gameboy sound player for GBS format"
HOMEPAGE="http://gbsplay.berlios.de"
SRC_URI="mirror://berlios/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="alsa? ( media-libs/alsa-lib:0 )
	nas? ( media-libs/nas:0 )"

DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext:0 )"

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
	rm -rf "${D}"/usr/share/locale/$1
}

src_install() {
	default

	l10n_for_each_disabled_locale_do remove_disabled_locale
}
