# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde4-base

DESCRIPTION="KDE utility to translate DocBook XML files using gettext po files"
KEYWORDS=" ~amd64 ~x86"
IUSE="debug"

DEPEND="sys-devel/gettext"
RDEPEND="${DEPEND}"
