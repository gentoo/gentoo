# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit xorg-2

DESCRIPTION="X.Org xlsclients application"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="
	>=x11-libs/libxcb-1.7
	>=x11-libs/xcb-util-0.3.8
"
DEPEND="${RDEPEND}"
