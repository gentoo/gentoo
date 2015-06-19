# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/wildmidi/wildmidi-0.3.7.ebuild,v 1.2 2014/06/07 10:29:51 hwoarang Exp $

EAPI=5
inherit cmake-utils readme.gentoo

DESCRIPTION="Midi processing library and a midi player using the gus patch set"
HOMEPAGE="http://www.mindwerks.net/projects/wildmidi/"
SRC_URI="http://github.com/Mindwerks/${PN}/archive/${P}.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
IUSE="+alsa openal oss +player"

DEPEND="player? (
	alsa? ( media-libs/alsa-lib )
	openal? ( media-libs/openal )
	)"
RDEPEND="${DEPEND}
	media-sound/timidity-freepats"

REQUIRED_USE="player? ( ^^ ( alsa oss openal ) )"

DOC_CONTENTS="${PN} is using timidity-freepats for midi playback.
	A default configuration file was placed on /etc/${PN}/${PN}.cfg.
	For more information please read the ${PN}.cfg manpage."

src_prepare() {
	# alsa openal oss only make sense if player is enabled. See CMakeLists.txt
	if ! use player && (use alsa || use openal || use oss); then
		ewarn
		ewarn "The 'alsa', 'openal' and 'oss' use flags only make sense if"
		ewarn "the 'player' use flags is selected and as a result they will be"
		ewarn "ignored in this build"
		ewarn
	fi
	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_want alsa)
		$(cmake-utils_use_want openal)
		$(cmake-utils_use_want oss)
		$(cmake-utils_use_want player)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	find "${D}" -name '*.la' -exec rm -f {} +
	insinto /etc/${PN}/
	doins cfg/${PN}.cfg
	readme.gentoo_create_doc
}

pkg_postinst() {
	if [[ -e "${ROOT}"/etc/${PN}.cfg ]]; then
		elog
		elog "Old /etc/${PN}.cfg detected!"
		elog "Please migrate your configuration file to"
		elog "/etc/${PN}/ directory which is now the default"
		elog "location for the ${PN} configuration file."
		elog
	fi
}
