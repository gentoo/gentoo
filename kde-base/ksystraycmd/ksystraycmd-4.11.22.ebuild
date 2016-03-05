# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KMNAME="kde-workspace"
inherit kde4-meta

DESCRIPTION="Ksystraycmd embeds applications given as argument into the system tray"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="x11-libs/libX11"
RDEPEND="${DEPEND}"
