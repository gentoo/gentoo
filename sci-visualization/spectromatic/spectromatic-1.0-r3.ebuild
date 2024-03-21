# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_P="${PN}_${PV}-1"

DESCRIPTION="Generates time-frequency analysis images from wav files"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"

LICENSE="GPL-1+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	media-libs/libpng:0=
	sci-libs/gsl:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-stringliteral.patch
	"${FILESDIR}"/${P}-waveheaderstruct-amd64.patch
)

src_configure() {
	tc-export CC PKG_CONFIG
	export TOPLEVEL_HOME="${EPREFIX}/usr"
}
