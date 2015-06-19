# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/font-isas-misc/font-isas-misc-1.0.3.ebuild,v 1.9 2012/05/13 16:38:57 aballier Exp $

EAPI=3
inherit xorg-2

DESCRIPTION="X.Org the Institute of Software, Academia Sinica (chinese) fonts"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	x11-apps/bdftopcf"
