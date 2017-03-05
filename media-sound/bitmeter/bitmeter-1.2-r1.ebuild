# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Diagnosis tool for JACK audio software"
HOMEPAGE="http://devel.tlrmx.org/audio/"
SRC_URI="http://devel.tlrmx.org/audio/source/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="doc"

RDEPEND="x11-libs/gtk+:2
	media-sound/jack-audio-connection-kit"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2-fix-build-system.patch
	"${FILESDIR}"/${PN}-1.2-qa-desktop-file.patch
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_install() {
	use doc && local HTML_DOCS=( doc/*.{png,html} )
	default
}
