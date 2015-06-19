# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/ohsnap/ohsnap-1.8.0.ebuild,v 1.1 2015/02/20 07:41:44 yngwin Exp $

EAPI=5
inherit font

DESCRIPTION="The ohsnap / osnap monospace font (based on Artwiz Snap)"
HOMEPAGE="http://sourceforge.net/projects/osnapfont"
SRC_URI="mirror://sourceforge/osnapfont/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

FONT_SUFFIX="pcf"
DOCS="README.ohsnap"
