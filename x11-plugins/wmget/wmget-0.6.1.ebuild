# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="a libcurl based dockapp for automated downloads"
HOMEPAGE="https://www.dockapps.net/wmget"
SRC_URI="https://www.dockapps.net/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm
	>=net-misc/curl-7.9.7"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

# Specific to this tarball
S=${WORKDIR}/dockapps-5aaf842

src_prepare() {
	default

	eautoreconf
}
