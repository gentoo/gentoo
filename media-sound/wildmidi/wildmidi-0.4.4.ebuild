# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake readme.gentoo-r1

DESCRIPTION="MIDI processing library and player using the GUS patch set"
HOMEPAGE="http://www.mindwerks.net/projects/wildmidi/"
SRC_URI="https://github.com/Mindwerks/${PN}/archive/${P}.tar.gz"

LICENSE="GPL-3+ LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
IUSE="+alsa openal oss +player"

DEPEND="
	player? (
		alsa? ( media-libs/alsa-lib )
		openal? ( media-libs/openal )
	)
"
RDEPEND="${DEPEND}
	media-sound/timidity-freepats
"

REQUIRED_USE="player? ( ^^ ( alsa oss openal ) )"

DOC_CONTENTS="${PN} is using timidity-freepats for midi playback.
	A default configuration file was placed on /etc/${PN}/${PN}.cfg.
	For more information please read the ${PN}.cfg manpage."

S="${WORKDIR}/${PN}-${P}"

src_prepare() {
	cmake_src_prepare
	# Fix location of media-sound/timidity-freepats
	# See #749759
	sed -i -e "s:midi/freepats:timidity/freepats:" cfg/wildmidi.cfg || die
}

src_configure() {
	local mycmakeargs=(
		-DWANT_ALSA=$(usex alsa)
		-DWANT_OPENAL=$(usex openal)
		-DWANT_OSS=$(usex oss)
		-DWANT_PLAYER=$(usex player)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	insinto /etc/${PN}/
	doins cfg/wildmidi.cfg

	readme.gentoo_create_doc
}
