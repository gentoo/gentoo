# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/X11-Protocol/X11-Protocol-0.560.0-r1.ebuild,v 1.1 2014/08/22 20:37:43 axs Exp $

EAPI=5

MODULE_AUTHOR=SMCCAM
MODULE_VERSION=0.56
inherit perl-module

DESCRIPTION="Client-side interface to the X11 Protocol"

LICENSE="${LICENSE} MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE=""

RDEPEND="x11-libs/libXrender
	x11-libs/libXext"
DEPEND="${RDEPEND}"
