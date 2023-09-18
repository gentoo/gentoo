# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Libcurl based dockapp for automated downloads"
HOMEPAGE="https://www.dockapps.net/wmget"
SRC_URI="https://www.dockapps.net/download/${P}.tar.gz"
# Specific to this tarball
S="${WORKDIR}/dockapps-5aaf842"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm
	>=net-misc/curl-7.9.7"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

src_prepare() {
	default
	eautoreconf
}
