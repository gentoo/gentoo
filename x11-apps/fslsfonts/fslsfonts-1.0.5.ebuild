# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit xorg-2

DESCRIPTION="list fonts served by X font server"
KEYWORDS="amd64 arm ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="x11-proto/xproto
	x11-libs/libFS"
DEPEND="${RDEPEND}"
