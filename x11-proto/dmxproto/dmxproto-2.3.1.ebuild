# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-proto/dmxproto/dmxproto-2.3.1.ebuild,v 1.8 2012/05/11 02:59:23 aballier Exp $

EAPI=3

inherit xorg-2

DESCRIPTION="X.Org DMX protocol headers"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="!<x11-libs/libdmx-1.0.99.1"
DEPEND="${RDEPEND}"
