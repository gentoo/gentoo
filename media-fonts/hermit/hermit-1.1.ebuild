# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/hermit/hermit-1.1.ebuild,v 1.1 2013/10/25 17:45:44 yngwin Exp $

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
