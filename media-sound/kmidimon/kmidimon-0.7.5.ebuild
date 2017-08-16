# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

KDE_LINGUAS="cs es ja"
KDE_HANDBOOK="optional"
QT3SUPPORT_REQUIRED="true"
inherit kde4-base

DESCRIPTION="A MIDI monitor for ALSA sequencer"
HOMEPAGE="http://kmidimon.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

RDEPEND="
	media-libs/alsa-lib
	>=media-sound/drumstick-0.5
	<media-sound/drumstick-1.0.0
"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README TODO )
PATCHES=( "${FILESDIR}/${P}-kdelibs-4.14.11.patch" )

src_configure() {
	local mycmakeargs=(
		-DSTATIC_DRUMSTICK=OFF
	)

	kde4-base_src_configure
}
