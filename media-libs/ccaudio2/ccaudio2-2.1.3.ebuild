# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF="1"

inherit autotools-utils

DESCRIPTION="C++ class framework for manipulating audio data"
HOMEPAGE="https://www.gnu.org/software/ccaudio"
SRC_URI="mirror://gnu/ccaudio/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug static-libs +speex gsm"

RDEPEND="dev-libs/ucommon
	gsm? ( media-sound/gsm )
	speex? ( media-libs/speex )
	"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	"

PATCHES=("${FILESDIR}"/disable_gsm_automagic.patch)
DOCS=(AUTHORS ChangeLog INSTALL NEWS README SUPPORT THANKS TODO)

REQUIRED_USE="^^ ( gsm speex )"

src_configure() {
	local myeconfargs=(
		$(use_enable speex)
		$(use_enable gsm)
	)
	autotools-utils_src_configure
}
