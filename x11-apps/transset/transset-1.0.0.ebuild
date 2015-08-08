# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit xorg-2

DESCRIPTION="An utility for setting opacity property"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/xapps http://cgit.freedesktop.org/xorg/app/transset/"

LICENSE="SGI-B-2.0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}
	>=x11-proto/xproto-7.0.17"

PATCHES=( "${FILESDIR}"/${P}-no_transset-df.patch )
