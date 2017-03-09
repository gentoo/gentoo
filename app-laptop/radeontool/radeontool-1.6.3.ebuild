# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="Manage the backlight, external video output and registers of ATI Radeon cards"

HOMEPAGE="https://cgit.freedesktop.org/~airlied/radeontool/"
SRC_URI="https://people.freedesktop.org/~airlied/${PN}/${P}.tar.bz2"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 ppc x86"

IUSE=""

RDEPEND=">=x11-libs/libpciaccess-0.12.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	emake install DESTDIR="${D}"
}
