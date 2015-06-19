# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/eject/eject-0.ebuild,v 1.9 2015/03/03 10:12:10 dlan Exp $

DESCRIPTION="Virtual for the eject command"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="|| ( >=sys-apps/util-linux-2.22 sys-block/eject sys-block/eject-bsd )"
DEPEND=""
