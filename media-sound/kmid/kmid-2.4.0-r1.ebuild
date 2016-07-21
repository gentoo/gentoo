# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="optional"
KDE_LINGUAS="ca ca@valencia cs da de en_GB es fr gl nb nl pt pt_BR
sr sr@ijekavian sr@ijekavianlatin sr@Latn sv tr uk zh_CN"
inherit kde4-base

DESCRIPTION="A MIDI/Karaoke player for KDE"
HOMEPAGE="https://userbase.kde.org/KMid"
SRC_URI="mirror://sourceforge/kmid2/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

RDEPEND="
	media-libs/alsa-lib
	>=media-sound/drumstick-0.4
	<media-sound/drumstick-1.0.0
"
DEPEND="${RDEPEND}"

DOCS=( ChangeLog README TODO )
