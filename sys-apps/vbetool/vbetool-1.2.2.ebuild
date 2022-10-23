# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Run real-mode video BIOS code to alter hw state (i.e. reinitialize video card)"
HOMEPAGE="https://cgit.freedesktop.org/~airlied/vbetool/"
SRC_URI="https://dev.gentoo.org/~ionen/distfiles/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/libx86
	sys-libs/zlib:=
	x11-libs/libpciaccess"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-libx86.patch
)

src_prepare() {
	default

	eautoreconf
}
