# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools

DESCRIPTION="a libcurl based dockapp for automated downloads"
HOMEPAGE="http://windowmaker.org/dockapps/?name=wmget"
# Grab from http://windowmaker.org/dockapps/?download=${P}.tar.gz
SRC_URI="https://dev.gentoo.org/~voyageur/distfiles/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm
	>=net-misc/curl-7.9.7"
DEPEND="${RDEPEND}
	x11-proto/xproto"

src_prepare() {
	default

	eautoreconf
}
