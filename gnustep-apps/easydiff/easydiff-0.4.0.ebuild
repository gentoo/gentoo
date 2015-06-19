# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/easydiff/easydiff-0.4.0.ebuild,v 1.6 2014/08/10 21:19:40 slyfox Exp $

inherit gnustep-2

MY_P=${P/easyd/EasyD}
DESCRIPTION="GNUstep app that lets you easily see the differences between two text files"
HOMEPAGE="http://wiki.gnustep.org/index.php/EasyDiff.app"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/usr-apps/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="cvs"

RDEPEND="cvs? ( dev-vcs/cvs )"

S=${WORKDIR}/${MY_P}
