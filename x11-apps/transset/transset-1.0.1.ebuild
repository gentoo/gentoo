# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/transset/transset-1.0.1.ebuild,v 1.3 2013/10/08 05:03:02 ago Exp $

EAPI=5
inherit xorg-2

DESCRIPTION="An utility for setting opacity property"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/xapps http://cgit.freedesktop.org/xorg/app/transset/"

LICENSE="SGI-B-2.0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}
	>=x11-proto/xproto-7.0.17"
