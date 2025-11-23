# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${P}-src"
inherit cmake flag-o-matic

DESCRIPTION="Analysis & Resynthesis Sound Spectrograph"
HOMEPAGE="https://arss.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"
CMAKE_USE_DIR="${S}/src"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="sci-libs/fftw:3.0="
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-cmake4.patch
)

DOCS=( ../AUTHORS ../ChangeLog )

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/859604
	# Upstream is on sourceforge, inactive since 2009. No bug filed.
	#
	# Do not trust it for LTO either.
	append-flags -fno-strict-aliasing
	filter-lto

	cmake_src_configure
}
