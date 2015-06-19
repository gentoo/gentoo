# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libXScrnSaver/libXScrnSaver-1.2.2.ebuild,v 1.9 2012/08/26 17:31:27 armin76 Exp $

EAPI=4
inherit xorg-2

DESCRIPTION="X.Org XScrnSaver library"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	>=x11-proto/scrnsaverproto-1.2"
DEPEND="${RDEPEND}"
