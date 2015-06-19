# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/qpitch/qpitch-1.0.1-r1.ebuild,v 1.1 2015/04/02 15:40:31 kensington Exp $

EAPI=5

inherit cmake-utils

DESCRIPTION="A program to tune musical instruments using Qt4"
HOMEPAGE="http://wspinell.altervista.org/qpitch/"
SRC_URI="http://download.gna.org/${PN}/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	>=media-libs/portaudio-19_pre20071207
	>=sci-libs/fftw-3.1.0
"
RDEPEND="${DEPEND}"

DOCS=( README changelog )
