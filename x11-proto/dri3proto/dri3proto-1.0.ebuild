# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-proto/dri3proto/dri3proto-1.0.ebuild,v 1.12 2015/03/03 12:25:22 dlan Exp $

EAPI=5
XORG_MULTILIB=yes
inherit xorg-2

DESCRIPTION="X.Org DRI3 protocol specification and Xlib/Xserver headers"

KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"
