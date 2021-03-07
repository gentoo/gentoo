# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="LXDE GUI interface to RandR extention"
HOMEPAGE="https://wiki.lxde.org/en/LXRandR"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.xz"

LICENSE="GPL-2"
KEYWORDS="~alpha amd64 arm ~arm64 ppc x86 ~x86-linux"
SLOT="0"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	x11-libs/libXrandr
	x11-apps/xrandr"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40.0
	sys-devel/gettext
	virtual/pkgconfig
	x11-base/xorg-proto"

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS
}
