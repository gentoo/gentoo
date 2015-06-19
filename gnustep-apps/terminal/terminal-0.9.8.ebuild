# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/terminal/terminal-0.9.8.ebuild,v 1.5 2012/12/28 03:32:30 ssuominen Exp $

EAPI=4

inherit gnustep-2

S=${WORKDIR}/${P/t/T}

DESCRIPTION="A terminal emulator for GNUstep"
HOMEPAGE="http://www.nongnu.org/terminal/"
SRC_URI="http://savannah.nongnu.org/download/gap/${P/t/T}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
SLOT="0"
IUSE=""

RDEPEND="!<x11-terms/terminal-0.6.0" #376257
DEPEND="${RDEPEND}"
