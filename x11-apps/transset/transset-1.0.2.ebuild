# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit xorg-2

DESCRIPTION="An utility for setting opacity property"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/xapps https://cgit.freedesktop.org/xorg/app/transset/"

LICENSE="SGI-B-2.0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
