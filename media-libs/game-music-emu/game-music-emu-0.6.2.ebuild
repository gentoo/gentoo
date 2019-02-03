# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib

DESCRIPTION="Video game music file emulators"
HOMEPAGE="https://bitbucket.org/mpyne/game-music-emu/wiki/Home"
SRC_URI="https://bitbucket.org/mpyne/game-music-emu/downloads/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 ~hppa ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

DOCS=( changes.txt design.txt gme.txt readme.txt )
