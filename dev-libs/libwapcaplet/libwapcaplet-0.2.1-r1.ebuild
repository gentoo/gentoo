# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libwapcaplet/libwapcaplet-0.2.1-r1.ebuild,v 1.1 2014/11/15 11:22:25 xmw Exp $

EAPI=5

NETSURF_BUILDSYSTEM=buildsystem-1.2
inherit netsurf

DESCRIPTION="string internment library, written in C"
HOMEPAGE="http://www.netsurf-browser.org/projects/libwapcaplet/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~m68k-mint"
IUSE="test"

DEPEND="test? ( >=dev-libs/check-0.9.11[${MULTILIB_USEDEP}] )"

PATCHES=( "${FILESDIR}"/${P}-glibc20.patch )
