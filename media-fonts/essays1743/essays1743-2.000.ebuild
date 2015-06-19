# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/essays1743/essays1743-2.000.ebuild,v 1.7 2012/08/27 17:38:40 armin76 Exp $

EAPI="4"

inherit font

DESCRIPTION="John Stracke's Essays 1743 font"
HOMEPAGE="http://www.thibault.org/fonts/essays/"
SRC_URI="http://www.thibault.org/fonts/essays/${P}-1-ttf.tar.gz"

LICENSE="|| ( LGPL-2.1 OFL-1.1 )"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc s390 sh sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${PN}"
FONT_S="${S}"
FONT_SUFFIX="ttf"
