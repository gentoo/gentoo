# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kephal/kephal-4.11.17.ebuild,v 1.1 2015/03/29 11:33:07 johu Exp $

EAPI=5

KMNAME="kde-workspace"
KMMODULE="libs/kephal"
inherit kde4-meta

DESCRIPTION="Allows handling of multihead systems via the XRandR extension"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXrandr
"
DEPEND="${RDEPEND}
	x11-proto/randrproto
"

KMEXTRACTONLY+="
	kephal/kephal/screens.h
"
