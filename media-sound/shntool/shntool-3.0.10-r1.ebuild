# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="A multi-purpose WAVE data processing and reporting utility"
HOMEPAGE="http://www.etree.org/shnutils/shntool/"
SRC_URI="http://www.etree.org/shnutils/shntool/dist/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="alac flac mac shorten sox wavpack"

RDEPEND="flac? ( media-libs/flac )
	mac? ( media-sound/mac )
	sox? ( media-sound/sox )
	alac? ( media-sound/alac_decoder )
	shorten? ( media-sound/shorten )
	wavpack? ( media-sound/wavpack )"
DEPEND="${RDEPEND}"

DOCS="NEWS README ChangeLog AUTHORS doc/*"
