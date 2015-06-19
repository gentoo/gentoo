# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/hermit/hermit-1.21.ebuild,v 1.1 2014/01/20 13:31:46 yngwin Exp $

EAPI=5
inherit font

DESCRIPTION="A monospace font designed to be clear, pragmatic and very readable"
HOMEPAGE="http://pcaro.es/p/hermit/"
SRC_URI="http://pcaro.es/d/otf-${P}.tar.gz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S=${WORKDIR}
FONT_SUFFIX="otf"
