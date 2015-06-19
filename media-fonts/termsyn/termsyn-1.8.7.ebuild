# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/termsyn/termsyn-1.8.7.ebuild,v 1.2 2013/09/10 13:06:33 xmw Exp $

EAPI=5

inherit font

DESCRIPTION="Monospaced font based on terminus and tamsyn"
HOMEPAGE="http://sourceforge.net/projects/termsyn/"
SRC_URI="mirror://sourceforge/${PN}/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

FONT_SUFFIX="pcf psfu"
