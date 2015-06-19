# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/font-bh-75dpi/font-bh-75dpi-1.0.3.ebuild,v 1.11 2014/09/29 16:36:48 ulm Exp $

EAPI=3
inherit xorg-2

DESCRIPTION="X.Org Bigelow & Holmes bitmap fonts"

LICENSE="public-domain"		# bitmap font, not copyrightable
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	x11-apps/bdftopcf"
