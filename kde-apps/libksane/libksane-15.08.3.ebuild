# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde4-base

DESCRIPTION="SANE Library interface for KDE"
KEYWORDS="amd64 x86"
IUSE="debug"
LICENSE="LGPL-2"

DEPEND="
	media-gfx/sane-backends
"
RDEPEND="${DEPEND}"
