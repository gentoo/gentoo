# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xlsfonts/xlsfonts-1.0.4.ebuild,v 1.8 2012/08/26 17:02:05 armin76 Exp $

EAPI=4

inherit xorg-2

DESCRIPTION="X.Org xlsfonts application"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-interix ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE=""
RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}"
