# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Dockapp mixer for OSS or ALSA"
HOMEPAGE="https://www.dockapps.net/wmix"
SRC_URI="https://www.dockapps.net/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="media-libs/alsa-lib
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm
	x11-libs/libXrandr"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
