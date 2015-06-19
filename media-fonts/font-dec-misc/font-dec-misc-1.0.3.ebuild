# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/font-dec-misc/font-dec-misc-1.0.3.ebuild,v 1.9 2012/05/13 17:35:34 aballier Exp $

EAPI=3
inherit xorg-2

DESCRIPTION="X.Org DEC fonts"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	x11-apps/bdftopcf"
