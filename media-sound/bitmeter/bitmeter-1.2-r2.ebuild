# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Diagnosis tool for JACK audio software"
HOMEPAGE="https://devel.tlrmx.org/audio/"
SRC_URI="https://devel.tlrmx.org/audio/source/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="doc"

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	virtual/jack
	x11-libs/gtk+:2
"
RDEPEND="${DEPEND}"

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
