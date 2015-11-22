# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE digital camera manager"
KEYWORDS=" ~amd64 ~x86"
IUSE="debug"

DEPEND="
	media-libs/libgphoto2:=
"
RDEPEND="${DEPEND}"
