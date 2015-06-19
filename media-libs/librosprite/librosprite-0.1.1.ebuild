# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/librosprite/librosprite-0.1.1.ebuild,v 1.1 2014/11/15 12:19:38 xmw Exp $

EAPI=5

NETSURF_BUILDSYSTEM=buildsystem-1.2
inherit netsurf

DESCRIPTION="framebuffer abstraction library, written in C"
HOMEPAGE="http://www.netsurf-browser.org/projects/librosprite/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~m68k-mint"
IUSE=""

PATCHES=( "${FILESDIR}"/${P}-Werror.patch )
