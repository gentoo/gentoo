# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/ccaudio2/ccaudio2-2.1.3.ebuild,v 1.1 2014/06/27 09:00:05 maksbotan Exp $

EAPI=5

AUTOTOOLS_AUTORECONF="1"

inherit autotools-utils

DESCRIPTION="C++ class framework for manipulating audio data"
HOMEPAGE="http://www.gnu.org/software/ccaudio"
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
