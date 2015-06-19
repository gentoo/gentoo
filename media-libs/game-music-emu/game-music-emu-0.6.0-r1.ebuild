# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/game-music-emu/game-music-emu-0.6.0-r1.ebuild,v 1.8 2015/02/24 08:43:36 ago Exp $

EAPI=5
inherit cmake-multilib

DESCRIPTION="Video game music file emulators"
HOMEPAGE="http://code.google.com/p/game-music-emu/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

DOCS="changes.txt design.txt gme.txt readme.txt"
