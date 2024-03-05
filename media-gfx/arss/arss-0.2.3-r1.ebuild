# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_IN_SOURCE_BUILD="true"
MY_P="${P}-src"
inherit cmake flag-o-matic

DESCRIPTION="Analysis & Resynthesis Sound Spectrograph"
HOMEPAGE="https://arss.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}/src"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="sci-libs/fftw:3.0="
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

DOCS=( ../AUTHORS ../ChangeLog )

src_compile() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/859604
	# Upstream is on sourceforge, inactive since 2009. No bug filed.
	#
	# Do not trust it for LTO either.
	append-flags -fno-strict-aliasing
	filter-lto

	default
}
