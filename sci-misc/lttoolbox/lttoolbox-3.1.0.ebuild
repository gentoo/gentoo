# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-misc/lttoolbox/lttoolbox-3.1.0.ebuild,v 1.4 2011/07/29 06:11:09 bicatali Exp $

EAPI=4

DESCRIPTION="Toolbox for lexical processing, morphological analysis and generation of words"
HOMEPAGE="http://apertium.sourceforge.net"
SRC_URI="mirror://sourceforge/apertium/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/libxml2:2
	dev-libs/libxslt
	dev-libs/libpcre
	sys-libs/libunwind"
RDEPEND="${DEPEND}"
