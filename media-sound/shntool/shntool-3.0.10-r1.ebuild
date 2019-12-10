# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A multi-purpose WAVE data processing and reporting utility"
HOMEPAGE="http://www.etree.org/shnutils/shntool/"
SRC_URI="http://www.etree.org/shnutils/shntool/dist/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="alac flac mac shorten sox wavpack"

RDEPEND="
	alac? ( media-sound/alac_decoder )
	flac? ( media-libs/flac )
	mac? ( media-sound/mac )
	shorten? ( media-sound/shorten )
	sox? ( media-sound/sox )
	wavpack? ( media-sound/wavpack )"
DEPEND="${RDEPEND}"

src_configure() {
	export CONFIG_SHELL=${BASH}  # bug #527310
	default
}

src_install() {
	default
	dodoc -r doc/.
}
